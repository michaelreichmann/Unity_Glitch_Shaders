using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ButtonShader : MonoBehaviour
{
    //pixelate
    public int pixelateMin;
    public int pixelateMax;

    //rgb glitch
    public float rgbOffsetMin;
    public float rgbOffsetMax;
    public float rgbOffsetSpeedMin;
    public float rgbOffsetSpeedMax;
    public Texture rgbOffsetTexture;

    //sample strip
    public float sampleStripSizeMin;
    public float sampleStripSizeMax;
    public float sampleStripSpeedMin;
    public float sampleStripSpeedMax;

    private Shader pixelShader;
    private Shader rgbGlitchShader;
    private Shader sampleStripShader;
    private Shader defaultShader;

    public bool doInUpdate;

    private void Awake()
    {
        //assign shader once
        pixelShader = Shader.Find("Custom/ButtonShaderPixelate");
        rgbGlitchShader = Shader.Find("Custom/ButtonShaderRGBGlitch");
        sampleStripShader = Shader.Find("Custom/ButtonShaderSampleStrip");
        defaultShader = Shader.Find("UI/Default");

        SetMaterial(false);
    }

    private void Update()
    {
        if (doInUpdate)
        {
            SetMaterial(false);
        }
    }

    public void SetMaterial(bool isNotInAwake)
    {
        //iterate through all the buttons
        foreach (Transform button in transform)
        {
            //dont do it in start method
            if (isNotInAwake)
            {
                //destroy material
                DestroyImmediate(button.gameObject.GetComponent<Image>().material, true);
            }

            //probabillity
            int prob = Random.Range(0, 100);

            if(prob > 75)
            {
                //Pixel
                button.gameObject.GetComponent<Image>().material = new Material(pixelShader);
                button.gameObject.GetComponent<Image>().material.SetFloat("_Pixelate", Random.Range(pixelateMin, pixelateMax));
            }
            else if (prob > 50)
            {
                //RGB Glitch
                button.gameObject.GetComponent<Image>().material = new Material(rgbGlitchShader);
                button.gameObject.GetComponent<Image>().material.SetFloat("_offset", Random.Range(rgbOffsetMin, rgbOffsetMax));
                button.gameObject.GetComponent<Image>().material.SetFloat("_speed", Random.Range(rgbOffsetSpeedMin, rgbOffsetSpeedMax));
                button.gameObject.GetComponent<Image>().material.SetTexture("_DistortionTex", rgbOffsetTexture);
            }
            else if (prob > 25)
            {
                //SampleStrip
                button.gameObject.GetComponent<Image>().material = new Material(sampleStripShader);
                button.gameObject.GetComponent<Image>().material.SetFloat("_size", Random.Range(sampleStripSizeMin, sampleStripSizeMax));
                button.gameObject.GetComponent<Image>().material.SetInt("_direction", Random.Range(0,1));
                button.gameObject.GetComponent<Image>().material.SetFloat("_speed", Random.Range(sampleStripSpeedMin, sampleStripSpeedMax));
            }
            else
            {
                //Default
                button.gameObject.GetComponent<Image>().material = new Material(defaultShader);
            }
        }
    }
}
