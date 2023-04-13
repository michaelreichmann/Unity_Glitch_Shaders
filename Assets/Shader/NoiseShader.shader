Shader "Hidden/NoiseShader"
{
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _amp ("noise amplitude", Range (0, 1)) = 0
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform float _amp;

            float4 frag(v2f_img i) : COLOR {
                float4 c = tex2D(_MainTex, i.uv);

                //noise
                float2 norm = i.uv;
                float2 vec_2 = float2(12.9898, 78.233002);
                float dot_3 = dot(norm, vec_2);
                float sin_4 = sin(dot_3);
                float mul_5 = sin_4 * 43758.546875;
                float add_6 = mul_5 + _Time * 100;
                float noise = frac(add_6);

                return lerp(c, noise, _amp);
            }
            ENDCG
        }
    }
}