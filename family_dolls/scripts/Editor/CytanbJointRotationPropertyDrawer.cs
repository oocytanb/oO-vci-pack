using System;

using UnityEngine;
using UnityEditor;

namespace cytanb
{
    [CustomPropertyDrawer(typeof(CytanbFamilyDollProperties.JointRotation))]
    public class CytanbJointRotationPropertyDrawer : PropertyDrawer
    {
        static readonly float lineHeight = EditorGUIUtility.singleLineHeight +
                                    EditorGUIUtility.standardVerticalSpacing;
        public override void OnGUI(
            Rect position,
            SerializedProperty property,
            GUIContent label
        )
        {
            var fieldSize = new Vector2(
                position.width,
                EditorGUIUtility.singleLineHeight
            );

            property.isExpanded = EditorGUI.Foldout(
                new Rect(position)
                {
                    height = EditorGUIUtility.singleLineHeight,
                },
                property.isExpanded,
                label
            );

            if (property.isExpanded)
            {
                using (new EditorGUI.IndentLevelScope())
                {
                    // Name property
                    property.NextVisible(true);
                    EditorGUI.PropertyField(
                        new Rect(position)
                        {
                            y = position.y + lineHeight,
                            height = EditorGUIUtility.singleLineHeight,
                        },
                        property,
                        true
                    );

                    // Rotation property
                    property.NextVisible(true);
                    var euler = EditorGUI.Vector3Field(
                        new Rect(position)
                        {
                            y = position.y + lineHeight * 2.0f,
                            height = EditorGUIUtility.singleLineHeight,
                        },
                        property.displayName,
                        property.quaternionValue.eulerAngles
                    );
                    property.quaternionValue = Quaternion.Euler(euler);
                }
            }
        }

        public override float GetPropertyHeight(
            SerializedProperty property,
            GUIContent label
        )
        {
            return property.isExpanded
                ? lineHeight * 3.0f
                : lineHeight;
        }
    }
}
