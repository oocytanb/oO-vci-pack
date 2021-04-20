// SPDX-License-Identifier: MIT
// Copyright (c) 2021 oO (https://github.com/oocytanb)

using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace cytanb
{
    using AssignColliderBounds = Func<Collider, Collider, bool>;

    [ExecuteInEditMode]
    public class CytanbMeshForColliderBounds : MonoBehaviour
    {
        const string ActionName = "SetColliderBounds";

        public enum ColliderType
        {
            Box,
            Capsule,
            Sphere,
        }

        static readonly Type[] ColliderComponentList =
        {
            typeof(BoxCollider),
            typeof(CapsuleCollider),
            typeof(SphereCollider),
        };

        struct ColliderOperation
        {
            public ColliderType colliderType;

            public Type componentType;

            public AssignColliderBounds assignColliderBounds;
        }

        static readonly Dictionary<ColliderType, ColliderOperation> OperationMap =
            new ColliderOperation[]
            {
                new ColliderOperation
                {
                    colliderType = ColliderType.Box,
                    componentType = typeof(BoxCollider),
                    assignColliderBounds = (Collider dest, Collider src) =>
                    {
                        BoxCollider d = dest as BoxCollider;
                        BoxCollider s = src as BoxCollider;

                        if (d.center == s.center && d.size == s.size)
                        {
                            return false;
                        }
                        else
                        {
                            d.center = s.center;
                            d.size = s.size;
                            return true;
                        }
                    }
                },
                new ColliderOperation
                {
                    colliderType = ColliderType.Capsule,
                    componentType = typeof(CapsuleCollider),
                    assignColliderBounds = (Collider dest, Collider src) =>
                    {
                        CapsuleCollider d = dest as CapsuleCollider;
                        CapsuleCollider s = src as CapsuleCollider;

                        if (d.center == s.center
                            && d.radius == s.radius
                            && d.height == s.height)
                        {
                            return false;
                        }
                        else
                        {
                            d.center = s.center;
                            d.radius = s.radius;
                            d.height = s.height;
                            return true;
                        }
                    }
                },
                new ColliderOperation
                {
                    colliderType = ColliderType.Sphere,
                    componentType = typeof(SphereCollider),
                    assignColliderBounds = (Collider dest, Collider src) =>
                    {
                        SphereCollider d = dest as SphereCollider;
                        SphereCollider s = src as SphereCollider;

                        if (d.center == s.center && d.radius == s.radius)
                        {
                            return false;
                        }
                        else
                        {
                            d.center = s.center;
                            d.radius = s.radius;
                            return true;
                        }
                    }
                },
            }.ToDictionary(o => o.colliderType);

        public Mesh mesh;

        public ColliderType colliderType;

        static void DestroyGameObject(GameObject go)
        {
#if UNITY_EDITOR
            if (EditorApplication.isPlaying)
            {
                GameObject.Destroy(go);
            }
            else
            {
                GameObject.DestroyImmediate(go);
            }
#else
            GameObject.Destroy(go);
#endif
        }

        static bool ProcessColliderBounds(Mesh mesh, ColliderOperation operation, Collider collider)
        {
            bool changed = false;
            var tg = new GameObject();
            try
            {
                var mf = tg.AddComponent<MeshFilter>();
                mf.sharedMesh = mesh;

                tg.AddComponent<MeshRenderer>();

                var c = tg.AddComponent(operation.componentType) as Collider;
                changed = operation.assignColliderBounds(collider, c);
            }
            finally
            {
                DestroyGameObject(tg);
            }
            return changed;
        }

#if UNITY_EDITOR
        void OnEnable()
        {
            var groupId = Undo.GetCurrentGroup();

            if (mesh == null)
            {
                // retrive mesh from MeshFilter if set and return
                var mf = gameObject.GetComponent<MeshFilter>();
                if (mf != null && mf.sharedMesh != null)
                {
                    Undo.RecordObject(this, ActionName);
                    mesh = mf.sharedMesh;
                }
                return;
            }

            foreach (var o in OperationMap.Values)
            {
                if (o.colliderType != colliderType)
                {
                    var c = gameObject.GetComponent(o.componentType);
                    if (c != null)
                    {
                        Undo.DestroyObjectImmediate(c);
                    }
                }
            }

            var operation = OperationMap[colliderType];
            var ct = operation.componentType;
            var collider = gameObject.GetComponent(ct) as Collider;
            if (collider == null)
            {
                collider = Undo.AddComponent(gameObject, ct) as Collider;
            }

            Undo.RecordObject(collider, ActionName);
            ProcessColliderBounds(mesh, operation, collider);

            Undo.CollapseUndoOperations(groupId);
        }
#endif
    }
}
