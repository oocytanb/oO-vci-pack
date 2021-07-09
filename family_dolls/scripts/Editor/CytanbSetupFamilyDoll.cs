// Usage
// =====
// 1. Attach `CytanbFamilyDollProperties` component to root object.
// 2. Attach `VCIObject' component to root object.
// 3. Execute `Setup family doll` from `cytanb` menu.
// **Template prefab: `family_doll_properties.prefab`**

using System;
using System.Collections.Generic;
using System.Linq;

using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

using VRM;
using VCI;

namespace cytanb
{
    using GameObjectResult = Result<GameObject, string>;
    using HumanoidAvatarResult = Result<(Avatar, Animator), string>;
    using DollPropertiesResult = Result<CytanbFamilyDollProperties, string>;
    using DollContextResult = Result<CytanbSetupFamilyDoll.DollContext, string>;

    public class CytanbSetupFamilyDoll : MonoBehaviour
    {
        internal class DollContext
        {
            public Scene scene;

            public string prefabPath;

            public GameObject root;

            public CytanbFamilyDollProperties properties;

            public Avatar avatar;

            public Animator animator;

            public GameObject characterRoot;

            public IEnumerable<string> jointNames;
        }

        const string ActionName = "Setup family doll";

        const string MenuItemKey = "Cytanb/" + ActionName;

        static Func<string, string> JointItemName => tagName
            => $"family_doll_joint#cytanb-joint={tagName}";

        static readonly string[] TargetJointTagNames = {
            "Head",
            "LeftUpperArm",
            "RightUpperArm",
            "LeftLowerArm",
            "RightLowerArm",
            "LeftHand",
            "RightHand",
            "LeftLowerLeg",
            "RightLowerLeg",
        };

        static void OutputDebugResult<T, E>(Result<T, E> rslt)
        {
            if (rslt.IsOk)
            {
                Debug.Log("[Ok] Complete!");
            }
            else
            {
                Debug.LogError($"[Err] {rslt.Error}");
            }
        }

        static string SelectedPrefabPath()
        {
            var go_ = Selection.activeObject;
            if (go_ == null || !PrefabUtility.IsPartOfPrefabAsset(go_))
            {
                return "";
            }
            else
            {
                var path_ = PrefabUtility
                    .GetPrefabAssetPathOfNearestInstanceRoot(go_);
                return path_ == null ? "" : path_;
            }
        }

        static TResult WithPrefabContents<TResult>(
            Func<Scene, string, GameObject, TResult> success,
            Func<string, TResult> fail,
            string path
        )
        {
            var scene = EditorSceneManager.NewPreviewScene();
            try
            {
                PrefabUtility.LoadPrefabContentsIntoPreviewScene(path, scene);
                var gos = scene.GetRootGameObjects();
                if (gos.Length >= 1)
                {
                    var go = gos[0];
                    try
                    {
                        return success(scene, path, go);
                    }
                    finally
                    {
                        PrefabUtility.UnloadPrefabContents(go);
                    }
                }
                else
                {
                    return fail(path);
                }
            }
            finally
            {
                EditorSceneManager.ClosePreviewScene(scene);
            }
        }

        static GameObjectResult SavePrefab(string path, GameObject root)
        {
            var p = PrefabUtility.SaveAsPrefabAsset(root, path, out var b);
            return b
                ? GameObjectResult.Ok(p)
                : GameObjectResult.Err("Failed to save prefab");
        }

        static Result<VCI.LicenseType, string> ToVciLicenseType(
            VRM.LicenseType licenseType
        )
        {
            var s = licenseType.ToString();
            return Enum.TryParse<VCI.LicenseType>(s, false, out var t)
                ? Result<VCI.LicenseType, string>.Ok(t)
                : Result<VCI.LicenseType, string>
                    .Err($"Invalid license type: {s}");
        }

        static Func<GameObject, HumanoidAvatarResult> HumanoidAvatar =>
            go =>
            {
                var anim_ = go.GetComponent<Animator>();
                var ava_ = anim_ == null ? null : anim_.avatar;
                return ava_ != null && ava_.isHuman
                    ? HumanoidAvatarResult.Ok((ava_, anim_))
                    : HumanoidAvatarResult.Err("Object is not humanoid avatar");
            };

        static Func<GameObject, DollPropertiesResult> DollProperties =>
            root =>
            {
                var props_ = root.GetComponent<CytanbFamilyDollProperties>();

                return props_ == null || props_.jointPrefab == null
                    ? DollPropertiesResult.Err("Invalid doll properties")
                    : DollPropertiesResult.Ok(props_);
            };

        static DollContextResult AddJointItemIfNotExists(
            string jointName,
            DollContext ctx
        )
        {
            var jointPrefab_ = ctx.properties.jointPrefab;
            if (jointPrefab_ == null)
            {
                return DollContextResult.Err("`JointPrefab` is not set");
            }
            else
            {
                var tf = ctx.root.transform;
                if (tf.Find(jointName) == null)
                {
                    var joint_ = PrefabUtility.InstantiatePrefab(
                        jointPrefab_,
                        ctx.scene
                    ) as GameObject;

                    if (joint_ == null)
                    {
                        return DollContextResult
                                .Err("Coult not instantiate joint");
                    }
                    else
                    {
                        joint_.name = jointName;
                        joint_.transform.SetParent(tf, false);
                        return DollContextResult.Ok(ctx);
                    }
                }
                else
                {
                    return DollContextResult.Ok(ctx);
                }
            }
        }

        static Func<Animator, GameObjectResult> CharacterBone =>
            animator =>
            {
                var hips_ = animator.GetBoneTransform(HumanBodyBones.Hips);

                var characterRoot_ = hips_ == null ? null : hips_.parent;

                var head_ = animator.GetBoneTransform(HumanBodyBones.Head);

                return characterRoot_ == null || head_ == null
                    ? GameObjectResult.Err("Invalid avatar")
                    : GameObjectResult.Ok(characterRoot_.gameObject);
            };

        static Func<DollContext, DollContextResult> SetupVciObject =>
            ctx =>
            {
                var root = ctx.root;

                var vciObj_ = root.GetComponent<VCIObject>();
                if (vciObj_ == null)
                {
                    var vrmMetaComponent_ = root.GetComponent<VRMMeta>();
                    var vrmMeta_ = vrmMetaComponent_ == null
                        ? null
                        : vrmMetaComponent_.Meta;

                    if (vrmMeta_ == null)
                    {
                        return DollContextResult.Err(
                            "`VRM Meta` component was not found"
                        );
                    }
                    else
                    {
                        var vciMeta = new VCIImporter.Meta
                        {
                            title = root.name,
                            version = vrmMeta_.Version,
                            thumbnail = vrmMeta_.Thumbnail,
                            author = vrmMeta_.Author,
                            contactInformation = vrmMeta_.ContactInformation,
                            reference = vrmMeta_.Reference,
                            modelDataOtherLicenseUrl = vrmMeta_.OtherLicenseUrl,
                            scriptOtherLicenseUrl = vrmMeta_.OtherLicenseUrl,
                        };

                        return ToVciLicenseType(vrmMeta_.LicenseType).AndThen(
                            licenseType =>
                            {
                                vciMeta.modelDataLicenseType = licenseType;
                                vciMeta.scriptLicenseType = licenseType;

                                var vciObj = root.AddComponent<VCIObject>();
                                vciObj.Meta = vciMeta;

                                return DollContextResult.Ok(ctx);
                            }
                        );
                    }
                }
                else
                {
                    return DollContextResult.Ok(ctx);
                }
            };

        static Func<DollContext, DollContextResult> SetupAnimationController =>
            ctx =>
            {
                var controller_ = ctx.properties.animatorController;
                if (controller_ != null)
                {
                    ctx.animator.runtimeAnimatorController = controller_;
                }
                return DollContextResult.Ok(ctx);
            };

        static Func<DollContext, Result<Bounds, string>> CharacterBounds =>
            ctx =>
            {
                var hips_ = ctx.animator.GetBoneTransform(HumanBodyBones.Hips);

                var b = false;
                var rsltBounds = new Bounds(Vector3.zero, Vector3.zero);
                var boundsSm = rsltBounds.size.sqrMagnitude;

                var tf = ctx.root.transform;
                for (var i = 0; i < tf.childCount; ++i)
                {
                    var child = tf.GetChild(i).gameObject;
                    var skin_ = child.GetComponent<SkinnedMeshRenderer>();
                    if (skin_ != null)
                    {
                        var bone_ = skin_.rootBone;
                        var bounds_ = skin_.bounds;
                        if (bone_ != null && bone_ == hips_ && bounds_ != null)
                        {
                            var sm = bounds_.size.sqrMagnitude;
                            if (!b || sm > boundsSm)
                            {
                                b = true;
                                rsltBounds = bounds_;
                                boundsSm = sm;
                            }
                        }
                    }
                }

                return b
                    ? Result<Bounds, string>.Ok(rsltBounds)
                    : Result<Bounds, string>.Err("Invalid avatar skin");
            };

        static Func<DollContext, DollContextResult> SetupCharacterRoot =>
            ctx =>
            (
                ctx.characterRoot.GetComponent<BoxCollider>() == null
                    ? CharacterBounds(ctx).AndThen(bounds =>
                        {
                            var collider = ctx.characterRoot
                                            .AddComponent<BoxCollider>();
                            collider.isTrigger = true;
                            collider.center = bounds.center;
                            collider.size = bounds.size;
                            return DollContextResult.Ok(ctx);
                        }
                    )
                    : DollContextResult.Ok(ctx)
            ).AndThen(x =>
                {
                    var charaRoot = x.characterRoot;
                    var prefab_ = x.properties.characterRootPrefab;

                    var srcRb_ = prefab_ == null
                        ? null
                        : prefab_.GetComponent<Rigidbody>();

                    if (srcRb_ != null &&
                        charaRoot.GetComponent<Rigidbody>() == null)
                    {
                        var rb = charaRoot.AddComponent<Rigidbody>();
                        rb.mass = srcRb_.mass;
                        rb.drag = srcRb_.drag;
                        rb.angularDrag = srcRb_.angularDrag;
                        rb.useGravity = srcRb_.useGravity;
                        rb.isKinematic = srcRb_.isKinematic;
                    }

                    var srcSi_ = prefab_ == null
                        ? null
                        : prefab_.GetComponent<VCISubItem>();

                    if (srcSi_ != null &&
                        charaRoot.GetComponent<VCISubItem>() == null)
                    {
                        var si = charaRoot.AddComponent<VCISubItem>();
                        si.Grabbable = srcSi_.Grabbable;
                        si.Scalable = srcSi_.Scalable;
                        si.UniformScaling = srcSi_.UniformScaling;
                        si.Attractable = srcSi_.Attractable;
                        si.GroupId = srcSi_.GroupId;
                    }

                    return DollContextResult.Ok(x);
                }
            );

        static Func<DollContext, DollContextResult> SetupCharacterHeadCollider =>
            ctx =>
            {
                var colliderPrefab_ = ctx.properties.headColliderPrefab;
                var srcCollider_ = colliderPrefab_ == null
                    ? null
                    : colliderPrefab_.GetComponent<BoxCollider>();

                if (srcCollider_ != null)
                {
                    var head_ = ctx.animator
                                .GetBoneTransform(HumanBodyBones.Head);
                    if (head_ == null)
                    {
                        return DollContextResult.Err("Invalid avatar");
                    }

                    var head = head_.gameObject;
                    if (head.GetComponent<BoxCollider>() == null)
                    {
                        var collider = head.AddComponent<BoxCollider>();
                        collider.isTrigger = srcCollider_.isTrigger;
                        collider.center = srcCollider_.center;
                        collider.size = srcCollider_.size;
                    }
                }

                return DollContextResult.Ok(ctx);
            };

        static Func<DollContext, DollContextResult> SetupCharacterBonesRotation =>
            ctx =>
            {
                var props = ctx.properties;
                var rotationList_ = props.jointRotationList;

                if (rotationList_ != null)
                {
                    foreach (var jointRotation in rotationList_)
                    {
                        var bone_ = ctx.animator.GetBoneTransform(
                            jointRotation.bone
                        );
                        if (bone_ != null)
                        {
                            bone_.localRotation = jointRotation.rotation;
                        }
                    }
                }

                return DollContextResult.Ok(ctx);
            };

        static Func<DollContext, DollContextResult> SetupJointItems =>
            ctx => ctx.jointNames.Aggregate(
                DollContextResult.Ok(ctx),
                (DollContextResult acc, string jointName) =>
                    acc.AndThen(x =>
                        AddJointItemIfNotExists(jointName, x)
                    )
            );

        static GameObjectResult SetupDollPrefab(string prefabPath)
        {
            return WithPrefabContents(
                (Scene scene, string path, GameObject root) =>
                    DollProperties(root).AndThen(properties =>
                        HumanoidAvatar(root).AndThen(
                            ((Avatar avatar, Animator animator) ta) =>
                                CharacterBone(ta.animator)
                                    .AndThen(characterRoot =>
                                        DollContextResult.Ok(new DollContext
                                        {
                                            scene = scene,
                                            prefabPath = path,
                                            root = root,
                                            properties = properties,
                                            avatar = ta.avatar,
                                            animator = ta.animator,
                                            characterRoot = characterRoot,
                                            jointNames = TargetJointTagNames
                                                .Select(JointItemName)
                                        })
                                    )
                        )
                    )
                    .AndThen(SetupVciObject)
                    .AndThen(SetupAnimationController)
                    .AndThen(SetupCharacterRoot)
                    .AndThen(SetupCharacterHeadCollider)
                    .AndThen(SetupCharacterBonesRotation)
                    .AndThen(SetupJointItems)
                    .AndThen(ctx => SavePrefab(ctx.prefabPath, ctx.root)),
                (string path) =>
                    GameObjectResult.Err(
                        $"Could not load a prefab: {path}"
                    ),
                prefabPath
            );
        }

        [MenuItem(MenuItemKey, true)]
        static bool ValidateMenu()
        {
            return !string.IsNullOrEmpty(SelectedPrefabPath());
        }

        [MenuItem(MenuItemKey, false, 500)]
        static void ExecuteMenu()
        {
            var prefabPath = SelectedPrefabPath();
            if (string.IsNullOrEmpty(prefabPath))
            {
                Debug.LogError("There is no selected prefab.");
                return;
            }

            try
            {
                AssetDatabase.StartAssetEditing();

                var rslt = SetupDollPrefab(prefabPath);
                OutputDebugResult(rslt);
            }
            finally
            {
                AssetDatabase.StopAssetEditing();
            }
        }
    }
}
