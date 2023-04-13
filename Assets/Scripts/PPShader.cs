using UnityEngine;
using System.Collections;

//[ExecuteInEditMode]
public class PPShader : MonoBehaviour
{
    public bool multiMaterial;

    public enum ShaderType
    {
        BW,
        pixel,
        noise,
        rgbGlitch,
        sampleStrip,
        wobble,
        motionblur,
        toon
    }

    public ShaderType shaderType;

    public int pixelate;

    public float noiseAmp;

    public float rgbOffset;
    public Texture rgbOffsetDistortionTexture;
    public float rgbOffsetSpeed;

    public float sampleStripSize;
    [Range(0,1)]
    public int sampleStripDirection;
    public float sampleStripSpeed;

    public float wobbleAmp;
    public float wobbleSpeed;
    public Texture wobbleDistortionTexture;

    public int motionBlurAmp;

    public int toonNumColors;

    //materials
    private Material bwMaterial;
    private Material pixelMaterial;
    private Material noiseMaterial;
    private Material rgbMaterial;
    private Material sampleStripMaterial;
    private Material wobbleMaterial;
    private Material motionBlurMaterial;
    private Material toonMaterial;

    private void Awake()
    {
        //create shader materials
        bwMaterial = new Material(Shader.Find("Hidden/BWDiffuseShader"));
        pixelMaterial = new Material(Shader.Find("Hidden/PixelShader"));
        noiseMaterial = new Material(Shader.Find("Hidden/NoiseShader"));
        rgbMaterial = new Material(Shader.Find("Hidden/RGBGlitchShader"));
        sampleStripMaterial = new Material(Shader.Find("Hidden/SampleStripShader"));
        wobbleMaterial = new Material(Shader.Find("Hidden/WobbleShader"));
        motionBlurMaterial = new Material(Shader.Find("Hidden/MotionBlurShader"));
        toonMaterial = new Material(Shader.Find("Hidden/ToonShader"));
    }


    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        //get Shader input
        //BW
        bwMaterial.SetFloat("_bwBlend", 1);
        //Pixel
        pixelMaterial.SetFloat("_pixelate", pixelate);
        //Noise
        noiseMaterial.SetFloat("_amp", noiseAmp);
        //RGB Glitch
        rgbMaterial.SetTexture("_DistortionTex", rgbOffsetDistortionTexture);
        rgbMaterial.SetFloat("_offset", rgbOffset);
        rgbMaterial.SetFloat("_speed", rgbOffsetSpeed);
        //Sample STrip
        sampleStripMaterial.SetFloat("_size", sampleStripSize);
        sampleStripMaterial.SetInt("_direction", sampleStripDirection);
        sampleStripMaterial.SetFloat("_speed", sampleStripSpeed);
        //Wobble
        wobbleMaterial.SetTexture("_DistortionTex", wobbleDistortionTexture);
        wobbleMaterial.SetFloat("_amp", wobbleAmp);
        wobbleMaterial.SetFloat("_speed", wobbleSpeed);
        //Motion Blur
        motionBlurMaterial.SetInt("_amp", motionBlurAmp);
        //toon
        toonMaterial.SetInt("_colors", toonNumColors);

        //single materials
        if (!multiMaterial)
        {
            if (shaderType == ShaderType.BW)
            {
                Graphics.Blit(source, destination, bwMaterial);
            }
            else if (shaderType == ShaderType.pixel)
            {
                Graphics.Blit(source, destination, pixelMaterial);
            }
            else if (shaderType == ShaderType.noise)
            {
                Graphics.Blit(source, destination, noiseMaterial);
            }
            else if (shaderType == ShaderType.rgbGlitch)
            {
                Graphics.Blit(source, destination, rgbMaterial);
            }
            else if (shaderType == ShaderType.sampleStrip)
            {
                Graphics.Blit(source, destination, sampleStripMaterial);
            }
            else if (shaderType == ShaderType.wobble)
            {
                Graphics.Blit(source, destination, wobbleMaterial);
            }
            else if (shaderType == ShaderType.motionblur)
            {
                Graphics.Blit(source, destination, motionBlurMaterial);
            }
            else if (shaderType == ShaderType.toon)
            {
                Graphics.Blit(source, destination, toonMaterial);
            }

        }
        //multiple materials
        else
        {
            //create temporary render textures
            RenderTexture tempA;
            RenderTexture tempB;
            RenderTexture tempC;
            RenderTexture tempD;
            RenderTexture tempE;
            RenderTexture tempF;
            RenderTexture tempG;

            tempA = RenderTexture.GetTemporary(source.width, source.height);
            tempB = RenderTexture.GetTemporary(source.width, source.height);
            tempC = RenderTexture.GetTemporary(source.width, source.height);
            tempD = RenderTexture.GetTemporary(source.width, source.height);
            tempE = RenderTexture.GetTemporary(source.width, source.height);
            tempF = RenderTexture.GetTemporary(source.width, source.height);
            tempG = RenderTexture.GetTemporary(source.width, source.height);

            //aplly materials in order
            Graphics.Blit(source, tempA, bwMaterial);
            Graphics.Blit(tempA, tempB, pixelMaterial);
            Graphics.Blit(tempB, tempC, noiseMaterial);
            Graphics.Blit(tempC, tempD, rgbMaterial);
            Graphics.Blit(tempD, tempE, sampleStripMaterial);
            Graphics.Blit(tempE, tempF, wobbleMaterial);
            Graphics.Blit(tempF, tempG, motionBlurMaterial);
            Graphics.Blit(tempG, destination, toonMaterial);

            //release textures
            RenderTexture.ReleaseTemporary(tempA);
            RenderTexture.ReleaseTemporary(tempB);
            RenderTexture.ReleaseTemporary(tempC);
            RenderTexture.ReleaseTemporary(tempD);
            RenderTexture.ReleaseTemporary(tempE);
            RenderTexture.ReleaseTemporary(tempF);
            RenderTexture.ReleaseTemporary(tempG);
        }
    }
}