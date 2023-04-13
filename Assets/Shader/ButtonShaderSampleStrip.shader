// https://answers.unity.com/questions/583960/apply-shader-to-a-sprite.html

Shader "Custom/ButtonShaderSampleStrip"
{
     Properties
     {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _size ("size of sample strip", Range (0, 1)) = 0
        _direction ("direction of the strip", Range (0,1)) = 0
        _speed ("speed of sample strip", Range (0, 1000)) = 0

     }
     SubShader
     {
         Tags 
         { 
             "RenderType" = "Opaque" 
             "Queue" = "Transparent+1" 
         }
 
         Pass
         {
             ZWrite Off
             Blend SrcAlpha OneMinusSrcAlpha 
  
             CGPROGRAM
             #pragma vertex vert
             #pragma fragment frag
             #pragma multi_compile DUMMY PIXELSNAP_ON
  
             uniform sampler2D _MainTex;
             uniform float _size;
             uniform int _direction;
             uniform float _speed;

             //map range to another range
             float map(float s, float a1, float a2, float b1, float b2)
             {
                 return b1 + (s-a1)*(b2-b1)/(a2-a1);
             }
 
             struct Vertex
             {
                 float4 vertex : POSITION;
                 float2 uv_MainTex : TEXCOORD0;
                 float2 uv2 : TEXCOORD1;
             };
     
             struct Fragment
             {
                 float4 vertex : POSITION;
                 float2 uv_MainTex : TEXCOORD0;
                 float2 uv2 : TEXCOORD1;
             };
  
             Fragment vert(Vertex v)
             {
                 Fragment o;
     
                 o.vertex = UnityObjectToClipPos(v.vertex);
                 o.uv_MainTex = v.uv_MainTex;
                 o.uv2 = v.uv2;
     
                 return o;
             }
                                                     
             float4 frag(Fragment IN) : COLOR
             {
                float pos = (_Time * _speed) % 1;

                float4 mask = float4(1,1,1,1);
                float4 sampleStrip;

                //horizontal
                if(_direction == 0)
                {
                    //create mask
                    if(IN.uv_MainTex.x < pos - _size * 0.5 || IN.uv_MainTex.x > pos + _size * 0.5)
                    {
                        mask = float4(0,0,0,0);
                    }

                    //sample at mask edges
                    float left = pos - (_size * 0.5);
                    float right = pos + (_size * 0.5);

                    float4 edgeLeft = tex2D(_MainTex, float2(left, IN.uv_MainTex.y));
                    float4 edgeRight = tex2D(_MainTex, float2(right, IN.uv_MainTex.y));

                    sampleStrip = lerp(edgeLeft, edgeRight, map(IN.uv_MainTex.x, left, right, 0, 1));
                }
                //vertical
                else
                {
                    //create mask
                    if(IN.uv_MainTex.y < pos - _size * 0.5 || IN.uv_MainTex.y > pos + _size * 0.5)
                    {
                        mask = float4(0,0,0,0);
                    }

                    //sample at mask edges
                    float up = pos - (_size * 0.5);
                    float down = pos + (_size * 0.5);

                    float4 edgeLeft = tex2D(_MainTex, float2(IN.uv_MainTex.x, up));
                    float4 edgeRight = tex2D(_MainTex, float2(IN.uv_MainTex.x, down));

                    sampleStrip = lerp(edgeLeft, edgeRight, map(IN.uv_MainTex.y, up, down, 0, 1));
                }

                //full image
                float4 image = tex2D(_MainTex, IN.uv_MainTex);
    
                return mask ? sampleStrip : image;

             }
 
             ENDCG
         }
     }
}