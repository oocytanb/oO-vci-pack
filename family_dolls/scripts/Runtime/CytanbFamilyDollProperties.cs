using System;

using UnityEngine;

namespace cytanb
{
    public class CytanbFamilyDollProperties : MonoBehaviour
    {
        [Serializable]
        public class JointRotation
        {
            public HumanBodyBones bone;

            public Quaternion rotation;
        }

        public RuntimeAnimatorController animatorController;

        public GameObject characterRootPrefab;

        public GameObject jointPrefab;

        public GameObject headColliderPrefab;

        public JointRotation[] jointRotationList;
    }
}
