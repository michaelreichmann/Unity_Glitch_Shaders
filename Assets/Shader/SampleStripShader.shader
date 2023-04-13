Shader "Hidden/SampleStripShader"
{
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _size ("size of sample strip", Range (0, 1000)) = 0
        _direction ("direction of the strip", Range (0,1)) = 0
        _speed ("speed of sample strip", Range (0, 1000)) = 0
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform float _size;
            uniform int _direction;
            uniform float _speed;

            //map range to another range
            float map(float s, float a1, float a2, float b1, float b2)
            {
                return b1 + (s-a1)*(b2-b1)/(a2-a1);
            }
 
            float4 frag(v2f_img i) : COLOR
            {
                float pos = (_Time * _speed) % 1;

                float4 mask = float4(1,1,1,1);
                float4 sampleStrip;

                //horizontal
                if(_direction == 0)
                {
                    //create mask
                    if(i.uv.x < pos - _size * 0.5 || i.uv.x > pos + _size * 0.5)
                    {
                        mask = float4(0,0,0,0);
                    }

                    //sample at mask edges
                    float left = pos - (_size * 0.5);
                    float right = pos + (_size * 0.5);

                    float4 edgeLeft = tex2D(_MainTex, float2(left, i.uv.y));
                    float4 edgeRight = tex2D(_MainTex, float2(right, i.uv.y));

                    sampleStrip = lerp(edgeLeft, edgeRight, map(i.uv.x, left, right, 0, 1));
                }
                //vertical
                else
                {
                    //create mask
                    if(i.uv.y < pos - _size * 0.5 || i.uv.y > pos + _size * 0.5)
                    {
                        mask = float4(0,0,0,0);
                    }

                    //sample at mask edges
                    float up = pos - (_size * 0.5);
                    float down = pos + (_size * 0.5);

                    float4 edgeLeft = tex2D(_MainTex, float2(i.uv.x, up));
                    float4 edgeRight = tex2D(_MainTex, float2(i.uv.x, down));

                    sampleStrip = lerp(edgeLeft, edgeRight, map(i.uv.y, up, down, 0, 1));
                }

                    //full image
                    float4 image = tex2D(_MainTex, i.uv);
    
                    return mask ? sampleStrip : image;

            }
            ENDCG
        }
    }
}