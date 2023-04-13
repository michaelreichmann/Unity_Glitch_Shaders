Shader "Hidden/WobbleShader"
{
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _DistortionTex ("Distortion (RGB)", 2D) = "white" {}
        _amp ("wobble strength", Range (0, 1)) = 0
        _speed ("wobble speed", Range (0, 1)) = 0
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform sampler2D _DistortionTex;
            uniform float _amp;
            uniform float _speed;

            float4 frag(v2f_img i) : COLOR {
                
                //mask
                float aspect = _ScreenParams.x /  _ScreenParams.y;
                float2 maskUV = (i.uv * 2) -1;
                maskUV *= float2(aspect, 1);
                float1 mask = length(maskUV);
                mask = pow(mask, 5);

                //movement
                float moveY = ((_Time * _speed) % 1);

                //turn texture
                float2 turnUV = float2(i.uv.y, i.uv.x);

                //animate texture
                float4 distortion;
                if(i.uv.x < 0.5)
                {
                    distortion  = tex2D(_DistortionTex, turnUV + float2(0, -moveY));
                }
                else
                {
                    distortion  = tex2D(_DistortionTex, turnUV + float2(0, moveY));
                }

                //create and apply distortionUV
                float2 distortionUV = distortion * _amp * mask;
                float4 pic = tex2D(_MainTex, i.uv + distortionUV);      
                return pic;
            }
            ENDCG
        }
    }
}