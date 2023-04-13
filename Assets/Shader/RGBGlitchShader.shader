Shader "Hidden/RGBGlitchShader"
{
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _DistortionTex ("Distortion (RGB)", 2D) = "white" {}
        _offset ("rgb offset", Range (0, 1)) = 0
        _speed ("offset speed", Range (0, 1)) = 0

    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform sampler2D _DistortionTex;
            uniform float _offset;
            uniform float _speed;  

            float4 frag(v2f_img i) : COLOR
            {
                //red channel
                float moveY = ((_Time * _speed) % 1);
                float4 distortion = tex2D(_DistortionTex, i.uv * float2(0.2, 0.2) + float2(1, moveY));

                float2 rUV = i.uv + _offset * distortion;

                float red = tex2D(_MainTex, rUV).r;

                //green and blue channel
                float2 greenBlue = tex2D(_MainTex, i.uv).gb;

                float4 c = float4(red, greenBlue.x, greenBlue.y, 1);
                
                //c = float4(rUV.x, rUV.y, 0,0);
                return c;
            }
            ENDCG
        }
    }
}