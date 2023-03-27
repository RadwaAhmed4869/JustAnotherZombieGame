using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CrowdSimulation : MonoBehaviour
{
    [SerializeField] float delayTime = 1f;
    [SerializeField] GameObject[] Waves;
    int i = 0;
    private void Start()
    {
        StartCoroutine(ActivateCrowdSimulation());
    }

    private IEnumerator ActivateCrowdSimulation()
    {
        foreach (GameObject wave in Waves)
        {
            yield return new WaitForSeconds(delayTime);
            wave.SetActive(true);
            delayTime += 30;
        }
    }
}
