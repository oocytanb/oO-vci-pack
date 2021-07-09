// SPDX-License-Identifier: MIT
// Copyright (c) 2019 oO (https://github.com/oocytanb)

using System.Collections.Generic;
using System.Linq;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace cytanb
{
    public class CytanbExportVCIPackageMenu
    {
        const string ACTION_NAME = "Export VCI Package";

        const string MENU_ITEM_KEY = "Cytanb/" + ACTION_NAME;

        const string PACKAGE_SUFFIX = "unitypackage";

        const string LUA_DIR = "Assets/oO-vci-pack/lua-modules";

        const string RUNTIME_SCRIPT_DIR = "Assets/oO-vci-pack/utility-scripts/Runtime";

        static readonly Dictionary<string, string> EXCLUDE_EXTENSIONS = (new string[]{".blend", ".blend1", ".xcf", ".cwp"}).ToDictionary(ext => ext);

        [MenuItem(MENU_ITEM_KEY, true)]
        static bool ValidateExportVCIPackageMenu()
        {
            return GetActiveObjectPath() != null;
        }

        [MenuItem(MENU_ITEM_KEY, false, 1)]
        static void ExportVCIPackageMenu()
        {
            var activePath = GetActiveObjectPath();
            if (activePath == null)
            {
                Debug.LogError("There is no selected object.");
                return;
            }

            // ディレクトリーでない場合は、親ディレクトリーをターゲットとする
            string targetPath = Directory.Exists(activePath) ? activePath : Path.GetDirectoryName(activePath);
            var outputPath = EditorUtility.SaveFilePanel("Save " + PACKAGE_SUFFIX, null, Path.GetFileName(targetPath) + "." + PACKAGE_SUFFIX, PACKAGE_SUFFIX);
            if (!string.IsNullOrWhiteSpace(outputPath)) {
                var assetPathList = AssetDatabase.FindAssets("", new string[]{targetPath, LUA_DIR, RUNTIME_SCRIPT_DIR})
                    .Select(guid => AssetDatabase.GUIDToAssetPath(guid))
                    .Distinct()
                    .Where(path => FilterAsset(path))
                    .ToArray();

                Debug.LogFormat("Export package: files = {0}, path = {1}, output = {2}", assetPathList.Count(), targetPath, outputPath);

                AssetDatabase.ExportPackage(assetPathList, outputPath, ExportPackageOptions.Interactive);
            }
        }

        static string GetActiveObjectPath()
        {
            var path = AssetDatabase.GetAssetOrScenePath(Selection.activeObject);
            return string.IsNullOrEmpty(path) ? null : path;
        }

        static bool FilterAsset(string assetPath)
        {
            if (string.IsNullOrEmpty(assetPath))
            {
                return false;
            }

            var ext = Path.GetExtension(assetPath);
            if (string.IsNullOrEmpty(ext)) {
                return true;
            }

            return !EXCLUDE_EXTENSIONS.ContainsKey(ext.ToLower());
        }
    }
}
