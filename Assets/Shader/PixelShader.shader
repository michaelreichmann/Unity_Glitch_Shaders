//https://www.alanzucconi.com/2015/07/08/screen-shaders-and-postprocessing-effects-in-unity3d/

Shader "Hidden/PixelShader"
{
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _pixelate ("number of pixels per axis", Range (0, 1000)) = 0
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform int _pixelate;

 

            float4 frag(v2f_img i) : COLOR
            {
                //include screen resolution to get square pixel
                float2 pixelate = float2(_ScreenParams.x /  _ScreenParams.y * _pixelate, _pixelate);

                float2 pixUV = floor(i.uv * pixelate) / pixelate;

                float4 c = tex2D(_MainTex, pixUV);
    
                return c;
            }
            ENDCG
        }
    }
}