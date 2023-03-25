using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class AudioManager : MonoBehaviour
{
    public static AudioManager instance;

    [SerializeField] Sound[] musicSounds, sfxSounds;
    [SerializeField] AudioSource musicSource, sfxSource;

   private void Awake()
    {
        if (instance == null)
        {
            instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }

    private void Start()
    {
        PlayMusic("Theme");
    }


    public void PlayMusic(string name)
    {

        Sound s = Array.Find(musicSounds , x=> x.name == name );

        //Debug.Log(s.name);

        if (s != null)
        {
            musicSource.clip = s.clip;
            musicSource.Play();
        }
    }


    public void playSFX(string name, float SFXVolume)
    {

        Sound s = Array.Find(sfxSounds , x => x.name == name);

        if (s != null)
        {
            sfxSource.PlayOneShot(s.clip, SFXVolume);
        }
       
    }

    }