// SPDX-License-Identifier: MIT
// Copyright (c) 2019 oO (https://github.com/oocytanb)

// ## Usage
// 1. Select VCI Object.
// 2. Run this script from `Cytanb/Generate cube-lump` menu.

using NAudio.Wave;
using System;
using System.IO;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;
using VCI;

namespace cytanb
{
    using GenerateCubePred = Func<Vector3Int, GameObject, GameObject, string, bool>;


    public static class CytanbGenerateCubeLump
    {
        enum GenerationType
        {
            Default,
            ColorMaterial,
            ColorMesh,
            LimitedColorMaterial,
        }

        const string ActionName = "Generate cube-lump";
        const string MenuItemName = "Cytanb/" + ActionName;
        const string BaseCubeName = "tenth-cube";
        const string PrefabCubeName = BaseCubeName + "-template";
        const string BoundsObjectRelativePath = "bounds-item/bounds-collider";
        const string MaterialDir = "materials";
        const string MaterialExt = ".mat";
        const string MeshDir = "meshes";
        const string MeshExt = ".asset";
        static readonly float TenthCubeEdgeLength = 0.1f;
        static readonly float TenthCubeInterval = 0.05f;
        static readonly int EdgeSize = 7;
        static readonly float EdgeLength = (TenthCubeEdgeLength + TenthCubeInterval) * EdgeSize - TenthCubeInterval;

        //static readonly GenerationType CustomGenerationType = GenerationType.Default;
        //static readonly GenerationType CustomGenerationType = GenerationType.ColorMaterial;
        //static readonly GenerationType CustomGenerationType = GenerationType.ColorMesh;
        static readonly GenerationType CustomGenerationType = GenerationType.LimitedColorMaterial;

        [MenuItem(MenuItemName, true)]
        static bool ValidatGenerateMatCubeMenu()
        {
            var root = Selection.activeObject as GameObject;
            return root && root.GetComponent<VCIObject>();
        }

        [MenuItem(MenuItemName, false, 500)]
        static void GenerateMatCubeMenu()
        {
            try
            {
                var groupId = Undo.GetCurrentGroup();

                var root = Selection.activeObject as GameObject;
                if (!root)
                {
                    Debug.LogError("There is no selected object.");
                    return;
                }

                var prefab = ResolvePrefab(PrefabCubeName, root);
                if (!prefab)
                {
                    Debug.LogError($"{PrefabCubeName}.prefab was not found.");
                    return;
                }

                Undo.RecordObject(root, ActionName);

                var boundsTransform = root.transform.Find(BoundsObjectRelativePath);
                if (!boundsTransform) {
                    Debug.LogError($"{BoundsObjectRelativePath}.prefab was not found.");
                    return;
                }

                // generate cubes
                var subprjDir = DirectoryPath(AssetDatabase.GetAssetPath(prefab));
                GenerateCubes(root, prefab, boundsTransform, subprjDir);

                Undo.CollapseUndoOperations(groupId);
            }
            catch (System.Exception e)
            {
                Debug.LogException(e);
            }
        }

        static bool PrepareDirectory(string path)
        {
            if (Directory.Exists(path))
            {
                return true;
            }

            var di = Directory.CreateDirectory(path);
            return di.Exists;
        }

        static Mesh CloneMesh(Mesh mesh)
        {
            var dest = new Mesh();
            foreach (var prop in typeof(Mesh).GetProperties())
            {
                if (prop.GetSetMethod() != null && prop.GetGetMethod() != null)
                {
                    prop.SetValue(dest, prop.GetValue(mesh));
                }
            }
            return dest;
        }

        static float CalcCubeEdgeOffset(int n)
        {
            return (-EdgeLength + TenthCubeEdgeLength) * 0.5f + (TenthCubeEdgeLength + TenthCubeInterval) * n;
        }

        static string CubeName(Vector3Int index3)
        {
            return $"{BaseCubeName}-{index3.x}-{index3.y}-{index3.z}";
        }

        static Color FullCubeColor(Vector3Int index3)
        {
            return Color.HSVToRGB((float)index3.x / EdgeSize, 1.0f - (float)index3.z / EdgeSize, (float)(index3.y + 1) / EdgeSize);
        }

        static bool GenerateCubes(GameObject root, GameObject templatePrefab, Transform boundsTransform, string subprjDir)
        {
            GenerateCubePred pred;
            switch (CustomGenerationType)
            {
                case GenerationType.ColorMaterial:
                    pred = ColorMaterialPred;
                    break;
                case GenerationType.ColorMesh:
                    pred = ColorMeshPred;
                    break;
                case GenerationType.LimitedColorMaterial:
                    pred = LimitedColorMaterialPred;
                    break;
                default:
                    pred = DefaultPred;
                    break;
            }
            boundsTransform.localScale = new Vector3(EdgeLength, EdgeLength, EdgeLength);

            for (int x = 0; x < EdgeSize; ++x)
            {
                for (int y = 0; y < EdgeSize; ++y)
                {
                    for (int z = 0; z < EdgeSize; ++z)
                    {
                        GenerateCube(new Vector3Int(x, y, z), root, boundsTransform.position, templatePrefab, subprjDir, pred);
                    }
                }
            }

            AssetDatabase.SaveAssets();
            return true;
        }

        static bool GenerateCube(Vector3Int index3, GameObject root, Vector3 boundsPosition, GameObject templatePrefab, string subprjDir, GenerateCubePred pred)
        {
            var name = $"{BaseCubeName}-{index3.x}-{index3.y}-{index3.z}";

            var goTransform = root.transform.Find(name);
            var go = goTransform ? goTransform.gameObject : null;
            var genGo = !go;
            if (genGo)
            {
                // ゲームオブジェクトが存在しない場合は、生成する。
                go = GameObject.Instantiate(templatePrefab);
                go.transform.SetParent(root.transform, false);

                var offsetPosition = new Vector3(CalcCubeEdgeOffset(index3.x), CalcCubeEdgeOffset(index3.y), CalcCubeEdgeOffset(index3.z));
                go.transform.localPosition = boundsPosition + offsetPosition;
                go.name = name;
            }

            var res = pred(index3, go, templatePrefab, subprjDir);

            if (genGo)
            {
                Undo.RegisterCreatedObjectUndo(go, ActionName);
            }

            return genGo || res;
        }

        static readonly GenerateCubePred DefaultPred = (Vector3Int index3, GameObject go, GameObject templatePrefab, string subprjDir) =>
        {
            return false;
        };

        static readonly GenerateCubePred ColorMaterialPred = (Vector3Int index3, GameObject go, GameObject templatePrefab, string subprjDir) =>
        {
            string name = CubeName(index3);
            Color color = FullCubeColor(index3);

            var materialDir = $"{subprjDir}/{MaterialDir}";
            if (!PrepareDirectory(materialDir))
            {
                Debug.LogError($"Could not parepare directory: {materialDir}");
                return false;
            }

            var materialPath = $"{materialDir}/{name}{MaterialExt}";
            var material = AssetDatabase.LoadAssetAtPath<Material>(materialPath);
            var genMaterial = !material;
            if (genMaterial)
            {
                // マテリアルファイルが存在しない場合は、生成する。
                // Debug.Log($"material path: {materialPath}");
                material = new Material(templatePrefab.GetComponent<Renderer>().sharedMaterial);
                material.color = color;
                if (material.HasProperty("_VColBlendMode"))
                {
                    // 頂点カラーをブレンドしない。
                    material.SetInt("_VColBlendMode", 0);
                }
                AssetDatabase.CreateAsset(material, materialPath);
            }
            go.GetComponent<Renderer>().sharedMaterial = material;

            return genMaterial;
        };

        static readonly GenerateCubePred ColorMeshPred = (Vector3Int index3, GameObject go, GameObject templatePrefab, string subprjDir) =>
        {
            string name = CubeName(index3);
            Color color = FullCubeColor(index3);

            var meshDir = $"{subprjDir}/{MeshDir}";
            if (!PrepareDirectory(meshDir))
            {
                Debug.LogError($"Could not parepare directory: {meshDir}");
                return false;
            }

            var meshPath = $"{meshDir}/{name}{MeshExt}";
            var mesh = AssetDatabase.LoadAssetAtPath<Mesh>(meshPath);
            var genMesh = !mesh;
            if (genMesh)
            {
                // メッシュファイルが存在しない場合は、生成する。
                // Debug.Log($"mesh path: {meshPath}");
                var prefabMeshFilter = templatePrefab.GetComponent<MeshFilter>();
                if (!prefabMeshFilter)
                {
                    return false;
                }

                var prefabMesh = prefabMeshFilter.sharedMesh;
                if (!prefabMesh)
                {
                    return false;
                }

                mesh = CloneMesh(prefabMesh);

                var vertexCount = mesh.vertexCount;
                var vertexColors = new Color[vertexCount];
                for (var i = 0; i < vertexCount; ++i)
                {
                    vertexColors[i] = color;
                }
                mesh.colors = vertexColors;


                AssetDatabase.CreateAsset(mesh, meshPath);
            }
            go.GetComponent<MeshFilter>().sharedMesh = mesh;

            return genMesh;
        };

        static readonly GenerateCubePred LimitedColorMaterialPred = (Vector3Int index3, GameObject go, GameObject templatePrefab, string subprjDir) =>
        {
            // 色相を、x 座標から決定する。
            //var limitedIndex3 = new Vector3Int(index3.x, EdgeSize - 1, (int) (EdgeSize * 0.25));

            // 色相を、座標から決定する。
            //var x = (index3.x + index3.y + index3.z) % EdgeSize;
            //var limitedIndex3 =  new Vector3Int(x, EdgeSize - 1, (int) (EdgeSize * 0.25));

            // 彩度を、座標から決定する。
            var x = (int) (EdgeSize * 0.7);
            var y = EdgeSize - 1;
            var z = (int) Mathf.PingPong(index3.x + index3.y + index3.z, EdgeSize - 1);
            var limitedIndex3 = new Vector3Int(x, y, z);

            return ColorMaterialPred(limitedIndex3, go, templatePrefab, subprjDir);
        };

        static string DirectoryPath(string path)
        {
            return Regex.Replace(path, @"\/[^/]*$", "");
        }

        static GameObject ResolvePrefab(string name, GameObject root = null)
        {
            string[] searchFolders;
            if (root)
            {
                var path = AssetDatabase.GetAssetOrScenePath(root);
                searchFolders = string.IsNullOrEmpty(path) ? null : new string[] { DirectoryPath(path) };
            }
            else
            {
                searchFolders = null;
            }

            foreach (var guid in AssetDatabase.FindAssets($"t:prefab {name}", searchFolders))
            {
                var path = AssetDatabase.GUIDToAssetPath(guid);
                if (!string.IsNullOrEmpty(path))
                {
                    var prefab = AssetDatabase.LoadAssetAtPath<GameObject>(path);
                    if (prefab && name.Equals(prefab.name))
                    {
                        return prefab;
                    }
                }
            }
            return null;
        }
    }
}
