// SPDX-License-Identifier: MIT
// Copyright (c) 2019 oO (https://github.com/oocytanb)

// cytanb-color-palette のオブジェクトを生成するスクリプトです。
// `UnityEditor Menu > Cytanb > Generate Color Palette` から実行します。

using UnityEditor;
using UnityEngine;
using VCI;

namespace cytanb
{
    public static class CytanbGenerateColorPaletteMenu
    {
        const string ACTION_NAME = "Generate Color Palette";
        const string MENU_ITEM_KEY = "Cytanb/" + ACTION_NAME;
        const int HUE_SAMPLES = 10;
        const int LIGHTNESS_SAMPLES = 4;
        const float COLOR_INDEX_POSITION_INTERVAL = 0.1f;
        const string COLOR_INDEX_PREFAB_NAME = "cytanb-color-index";
        const string COLOR_INDEX_OBJECT_PREFIX = COLOR_INDEX_PREFAB_NAME + "-";
        const string COLOR_PALETTE_BASE_NAME = "palette-base#cytanb-color-palette";

        [MenuItem(MENU_ITEM_KEY, true)]
        static bool ValidatGenerateColorPaletteMenu()
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

            return root.transform.Find(COLOR_PALETTE_BASE_NAME) && !root.transform.Find($"{COLOR_INDEX_OBJECT_PREFIX}0");
        }

        [MenuItem(MENU_ITEM_KEY, false, 500)]
        static void GenerateColorPaletteMenu()
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

                var paletteBaseTransform = root.transform.Find(COLOR_PALETTE_BASE_NAME);
                if (!paletteBaseTransform)
                {
                    Debug.LogError("There is no palette base.");
                    return;
                }
                var paletteBase = paletteBaseTransform.gameObject;

                var prefab = ResolvePrefab(COLOR_INDEX_PREFAB_NAME);
                if (!prefab)
                {
                    Debug.LogError($"{COLOR_INDEX_PREFAB_NAME}.prefab was not found.");
                    return;
                }

                Undo.RecordObject(root, ACTION_NAME);

                // generate color indexes
                var prefabPosition = prefab.transform.localPosition;
                for (int y = 0; y < LIGHTNESS_SAMPLES; ++y)
                {
                    GameObject lastXgo = null;
                    for (int x = 0; x < HUE_SAMPLES; ++x)
                    {
                        GameObject go = GameObject.Instantiate(prefab);
                        go.transform.SetParent(root.transform, false);
                        go.transform.localPosition = new Vector3(prefabPosition.x + COLOR_INDEX_POSITION_INTERVAL * x, prefabPosition.y - COLOR_INDEX_POSITION_INTERVAL * y, prefabPosition.z);
                        go.name = $"{COLOR_INDEX_OBJECT_PREFIX}{y * HUE_SAMPLES + x}";

                        var joint = go.GetComponent<FixedJoint>();
                        if (joint)
                        {
                            joint.connectedBody = ((lastXgo) ? lastXgo : paletteBase).GetComponent<Rigidbody>();
                        }

                        lastXgo = go;
                        Undo.RegisterCreatedObjectUndo(go, ACTION_NAME);
                    }
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
