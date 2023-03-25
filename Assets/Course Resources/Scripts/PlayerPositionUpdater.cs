using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PlayerPositionUpdater : MonoBehaviour {
    // Use this for initialization
    public Transform player;
    private Material[] _ground;

	void Start () {
        _ground= this.gameObject.GetComponent<Renderer>().materials;
	}
	
	// Update is called once per frame
	void Update () {
        _ground[0].SetVector("_Playerposition", new Vector3(player.transform.position.x, player.transform.position.y, player.transform.position.z));
	}
}