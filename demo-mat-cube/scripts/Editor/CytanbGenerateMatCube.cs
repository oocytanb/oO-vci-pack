// SPDX-License-Identifier: MIT
// Copyright (c) 2019 oO (https://github.com/oocytanb)

// - オブジェクトとマテリアルを生成するサンプルです。
// ## 使い方
// - `demo-mat-cube.scene` を開き、ルートの VCI オブジェクトの `cytanb-demo-mat-cube` を選択した状態で、
//   メニューから `Cytanb/Generate mat-cube` を実行します。
// - 5 個分のゲームオブジェクトと、マテリアルがそれぞれ生成されます。

using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;
using VCI;

namespace cytanb
{
    public static class CytanbGenerateMatCube
    {
        const string ACTION_NAME = "Generate mat-cube";
        const string MENU_ITEM_KEY = "Cytanb/" + ACTION_NAME;
        static readonly int CUBE_COUNT = 5;
        const float CUBE_POSITION_INTERVAL = 1.0f;
        const string CUBE_BASE_NAME = "demo-mat-cube";
        const string MATERIAL_DIR = "materials";
        const string MATERIAL_EXT = ".mat";
        const string TEXTURE_DIR = "textures";
        const string TEXTURE_EXT = ".png";

        [MenuItem(MENU_ITEM_KEY, true)]
        static bool ValidatGenerateMatCubeMenu()
        {
            var root = Selection.activeObject as GameObject;
            if (!root)
            {
                return false;
            }

            var vci = root.GetComponent<VCIObject>();
            if (!vci)
            {
                return false;
            }

            return true;
        }

        [MenuItem(MENU_ITEM_KEY, false, 500)]
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

                var prefab = ResolvePrefab(CUBE_BASE_NAME);
                if (!prefab)
                {
                    Debug.LogError($"{CUBE_BASE_NAME}.prefab was not found.");
                    return;
                }

                Undo.RecordObject(root, ACTION_NAME);

                // generate cubes
                var subprjDir = Regex.Replace(AssetDatabase.GetAssetPath(prefab), "\\/[^/]+$", "");
                for (int index = 1; index <= CUBE_COUNT; ++index)
                {
                    GenerateMatCube(index, root, prefab, subprjDir);
                }

                Undo.CollapseUndoOperations(groupId);
            }
            catch (System.Exception e)
            {
                Debug.LogException(e);
            }
        }

        static bool GenerateMatCube(int index, GameObject root, GameObject prefab, string subprjDir)
        {
            var goName = $"{CUBE_BASE_NAME}-{index}";
            var go = root.transform.Find(goName)?.gameObject;
            var genGo = !go;
            if (genGo) {
                // ゲームオブジェクトが存在しない場合は、生成する。
                go = GameObject.Instantiate(prefab);
                go.transform.SetParent(root.transform, false);
                var prefabPosition = prefab.transform.localPosition;
                go.transform.localPosition = new Vector3(prefabPosition.x + CUBE_POSITION_INTERVAL * index, prefabPosition.y, prefabPosition.z);
                go.name = goName;
            }

            var materialPath = $"{subprjDir}/{MATERIAL_DIR}/{CUBE_BASE_NAME}-{index}{MATERIAL_EXT}";
            var material = AssetDatabase.LoadAssetAtPath<Material>(materialPath);
            var genMaterial = !material;
            if (genMaterial) {
                // マテリアルファイルが存在しない場合は、生成する。
                // マテリアルのカラーとテクスチャーを変更する。
                Debug.Log($"material path: {materialPath}");
                material = new Material(prefab.GetComponent<Renderer>().sharedMaterial);
                material.color = Color.HSVToRGB((float) index / CUBE_COUNT, 1.0f, 1.0f);
                material.mainTexture = AssetDatabase.LoadAssetAtPath<Texture2D>($"{subprjDir}/{TEXTURE_DIR}/{CUBE_BASE_NAME}-{index}{TEXTURE_EXT}");
                AssetDatabase.CreateAsset(material, materialPath);
            }
            go.GetComponent<Renderer>().sharedMaterial = material;

            if (genGo) {
                Undo.RegisterCreatedObjectUndo(go, ACTION_NAME);
            }

            return genGo || genMaterial;
        }

        static GameObject ResolvePrefab(string name)
        {
            foreach (var guid in AssetDatabase.FindAssets($"t:prefab {name}"))
            {
                var path = AssetDatabase.GUIDToAssetPath(guid);
                if (string.IsNullOrEmpty(path))
                {
                    continue;
                }

                var prefab = AssetDatabase.LoadAssetAtPath<GameObject>(path);
                if (prefab && name.Equals(prefab.name))
                {
                    return prefab;
                }
            }
            return null;
        }
    }
}
