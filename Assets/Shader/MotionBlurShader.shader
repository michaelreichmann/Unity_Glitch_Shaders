Shader "Hidden/MotionBlurShader"
{
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _amp ("blur strength", Range (0, 100)) = 0
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform int _amp;

            float4 frag(v2f_img i) : COLOR {

                //mask
                float aspect = _ScreenParams.x /  _ScreenParams.y;
                float2 maskUV = (i.uv * 2) -1;
                maskUV *= float2(aspect, 1);
                float1 mask = length(maskUV);
                mask = pow(mask, 2);
                mask = clamp(mask,0,1);

                //amp can't be lower than 1
                _amp += 1;

                float4 pic = tex2D(_MainTex, i.uv);
                float4 tempColor;

                //sample texture on different positions along the y axis
	            for(int j = 0; j < _amp; j++)
	            {
		            float2 tempCoord = i.uv + float2(0, j/_ScreenParams.y);
		            tempColor += tex2D(_MainTex, tempCoord);
	            }
	            float4 blurPic = tempColor/_amp;	
                
                return lerp(pic, blurPic, float4(mask, mask, mask, mask));
            }
            ENDCG
        }
    }
}