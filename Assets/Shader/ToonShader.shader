//https://www.chilliant.com/rgb2hsv.html
//https://ragueel.medium.com/creating-simple-cell-shading-custom-post-process-in-hdrp-b3f2ea2b8c28

Shader "Hidden/ToonShader"
{
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _colors ("number of colors", Range (0, 100)) = 0
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform float _colors;
            float Epsilon = 1e-10;

            float3 RGBtoHCV(in float3 RGB)
            {
                // Based on work by Sam Hocevar and Emil Persson
                float Epsilon = 1e-10;
                float4 P = (RGB.g < RGB.b) ? float4(RGB.bg, -1.0, 2.0/3.0) : float4(RGB.gb, 0.0, -1.0/3.0);
                float4 Q = (RGB.r < P.x) ? float4(P.xyw, RGB.r) : float4(RGB.r, P.yzx);
                float C = Q.x - min(Q.w, Q.y);
                float H = abs((Q.w - Q.y) / (6 * C + Epsilon) + Q.z);
                return float3(H, C, Q.x);
            }

            float3 RGBtoHSV(in float3 RGB)
            {
                float3 HCV = RGBtoHCV(RGB);
                float S = HCV.y / (HCV.z + Epsilon);
                return float3(HCV.x, S, HCV.z);
            }

            float3 HUEtoRGB(in float H)
            {
                float R = abs(H * 6 - 3) - 1;
                float G = 2 - abs(H * 6 - 2);
                float B = 2 - abs(H * 6 - 4);
                return saturate(float3(R,G,B));
            }

            float3 HSVtoRGB(in float3 HSV)
            {
                float3 RGB = HUEtoRGB(HSV.x);
                return ((RGB - 1) * HSV.y + 1) * HSV.z;
            }

            float Posterize(float In, float steps)
            {
                return floor(In / (1 / steps)) * (1 / steps);
            }


            float4 frag(v2f_img i) : COLOR {
                float4 pic = tex2D(_MainTex, i.uv);

                float3 hsvColor = RGBtoHSV(pic.rgb);
                hsvColor.b = Posterize(hsvColor.b, _colors);

                pic.rgb = HSVtoRGB(hsvColor);

               return pic;
            }
            ENDCG
        }
    }
}