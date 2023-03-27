using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShootingGun : MonoBehaviour
{
    //public float range;
    public float impactForce = 30f;

    [SerializeField] float damage;

    [SerializeField] private Camera fpsCam;

    [SerializeField] private ParticleSystem muzzleBullet;
    [SerializeField] private ParticleSystem muzzleFire;

    private float randomValue;

    void Update()
    {
        if (Input.GetButtonDown("Jump"))
        {
            Shoot();
        }
    }

    void Shoot()
    {
        randomValue = Random.value;
        //Debug.Log(randomValue);
        if (randomValue > 0.2f)
        {
            AudioManager.instance.playSFX("Gunshot", 0.5f);
            muzzleFire.Play();
        }
        else
        {
            AudioManager.instance.playSFX("FireGun", 0.5f);
            muzzleBullet.Play();
        }

        RaycastHit hit;
        if (Physics.Raycast(fpsCam.transform.position, fpsCam.transform.forward, out hit))
        {
            //Debug.DrawRay(fpsCam.transform.position, fpsCam.transform.forward * range, Color.green, 5);
            //Debug.Log(hit.transform.tag);
            //Debug.Log(hit.transform.name);

            ZombieAI zombie = hit.transform.GetComponent<ZombieAI>();

            if (hit.rigidbody != null)
            {
                //hit.rigidbody.AddForce(-hit.transform.forward * impactForce, ForceMode.Impulse);
                zombie.TakeDamage(damage);
            }
        }

    }
}
