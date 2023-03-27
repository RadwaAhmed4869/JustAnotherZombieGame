using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class PlayerLife : MonoBehaviour
{
    private float maxHealth = 100;
    [SerializeField] private float health;

    [SerializeField] private Image redSplatter1 = null;
    [SerializeField] private Image redSplatter2 = null;

    [SerializeField] private Image gradientFlash = null;
    [SerializeField] private float hurtTime = 0.1f;

    [SerializeField] private TMP_Text gameOvertxt;
    [SerializeField] GameObject gunPin;

    private float randomValue;

    [SerializeField] AudioSource musicAudioSrc;


    private void Start()
    {
        health = maxHealth;
        gradientFlash.enabled = false;
        gameOvertxt.enabled = false;
    }

    void UpdateHealth()
    {
        Color splatterAlpha1 = redSplatter1.color;
        splatterAlpha1.a = (1 - (health / maxHealth))/2;
        redSplatter1.color = splatterAlpha1;
        /**
        // 90
        // (1 - (90 / 100)) / 2
        // (1 - 0.9) / 2
        // 0.1 / 2
        // 0.05

        // 10
        // (1 - 0.1) / 2
        // 0.9 / 2 = 0.45
        **/
        Color splatterAlpha2 = redSplatter2.color;
        splatterAlpha2.a = (1 - (health / maxHealth))/2;
        redSplatter2.color = splatterAlpha2;
    }

    IEnumerator HurtFlash()
    {
        gradientFlash.enabled = true;
        //play hurt audio
        yield return new WaitForSeconds(hurtTime);
        gradientFlash.enabled = false;

    }

    public void TakeDamage(float amount)
    {
        health -= amount;

        randomValue = Random.value;
        if (randomValue > 0.2f)
        {
            AudioManager.instance.playSFX("Pain2", 1f);
        }
        else
        {
            AudioManager.instance.playSFX("Pain1", 1f);

        }


        if (health > 0)
        {
            //can Regenerate health ?

            //hurt effect
            StartCoroutine(HurtFlash());
            UpdateHealth();

            //cooldown

            return;
        }

        Die();
    }

    void Die()
    {
        gameOvertxt.enabled = true;
        gradientFlash.enabled = true;
        gunPin.SetActive(false);
        musicAudioSrc.Stop();
        AudioManager.instance.playSFX("Pain1", 1f);
        Time.timeScale = 0;
    }

    //private void OnTriggerEnter(Collider other)
    //{
    //    Debug.Log(other.tag);
    //    if(other.tag.Equals("Crow"))
    //    {
    //        TakeDamage(10);        }
    //}
}
