// SPDX-License-Identifier: MIT
// Copyright (c) 2019 oO (https://github.com/oocytanb)

// - オブジェクトとマテリアルを生成するサンプルです。
// ## 使い方
// - `demo-mat-cube.scene` を開き、ルートの VCI オブジェクトの `demo-mat-cube-root` を選択した状態で、
//   メニューから `Cytanb/Generate mat-cube` を実行します。
// - 5 個分のゲームオブジェクトと、マテリアルがそれぞれ生成されます。

using UnityEditor;
using UnityEngine;
using VCI;

namespace cytanb
{
    public static class CytanbGenerateMatCube
    {
        const string ACTION_NAME = "Generate mat-cube";
        const string MENU_ITEM_KEY = "Cytanb/" + ACTION_NAME;
        const float CUBE_POSITION_INTERVAL = 1.0f;
        const string CUBE_PREFAB_NAME = "demo-mat-cube";
        const string CUBE_OBJECT_PREFIX = CUBE_PREFAB_NAME + "-";
        const string MATERIAL_PREFIX = "demo-mat-";
        const string MATERIAL_DIR = "materials";
        const int GENERATION_COUNT = 5;

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

                var prefab = ResolvePrefab(CUBE_PREFAB_NAME);
                if (!prefab)
                {
                    Debug.LogWarning(CUBE_PREFAB_NAME + ".prefab was not found.");
                }

                Undo.RecordObject(root, ACTION_NAME);

                // generate cubes
                var prefabPath = AssetDatabase.GetAssetPath(prefab);
                var prefabMaterial = prefab.GetComponent<Renderer>().sharedMaterial;
                var prefabPosition = prefab.transform.localPosition;
                var subprjDir = System.Text.RegularExpressions.Regex.Replace(prefabPath, "\\/[^/]+$", "");

                for (int i = 0; i < GENERATION_COUNT; ++i)
                {
                    var genIndex = (i + 1);

                    var goName = CUBE_OBJECT_PREFIX + genIndex;
                    GameObject go = root.transform.Find(goName)?.gameObject;
                    if (!go) {
                        // ゲームオブジェクトが存在しない場合は、生成する。
                        go = GameObject.Instantiate(prefab);
                        go.transform.SetParent(root.transform, false);
                        go.transform.localPosition = new Vector3(prefabPosition.x + CUBE_POSITION_INTERVAL * i, prefabPosition.y, prefabPosition.z);
                        go.transform.localRotation = prefab.transform.localRotation;
                        go.transform.localScale = prefab.transform.localScale;
                        go.name = goName;
                    }

                    var materialPath = subprjDir + "/" + MATERIAL_DIR + "/" + MATERIAL_PREFIX + genIndex + ".mat";

                    var renderer = go.GetComponent<Renderer>();
                    var material = AssetDatabase.LoadAssetAtPath<Material>(materialPath);
                    if (!material) {
                        // マテリアルファイルが存在しない場合は、生成する。
                        // サンプルとして、マテリアルのカラーを変更する。
                        Debug.LogFormat("material path: {0}", materialPath);
                        material = new Material(prefabMaterial);
                        material.color = Color.HSVToRGB((float) i / GENERATION_COUNT, 1.0f, 1.0f);
                        AssetDatabase.CreateAsset(material, materialPath);
                    }
                    renderer.sharedMaterial = material;

                    Undo.RegisterCreatedObjectUndo(go, ACTION_NAME);
                }

                Undo.CollapseUndoOperations(groupId);
            }
            catch (System.Exception e)
            {
                Debug.LogException(e);
            }
        }

        private static GameObject ResolvePrefab(string name)
        {
            foreach (var guid in AssetDatabase.FindAssets("t:prefab " + name))
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
