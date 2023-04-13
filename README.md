# Unity Glitch Shader

*UNITY 2021.3.16f1*

Unity Project containing 8 Post Processing and 3 Sprite/UI Shaders (HLSL). <br/>
The shaders are controlled via the *PPShader-Script* on the *Main Camera*. <br/>
The *PPShader-Script* lets you choose between the different shaders, or select all at once ("*Multi Material*"). <br/>
The project also contains the **Unity Post Processing Package**. The HLSL post processing shaders are applied *after* the Unity Post Processing Package shaders.<br/>


## Post Processing Shaders
### BW[^1]
Black and White Effect. <br/>

### Pixel
Pixelate Effect. <br/>
**Pixelate**: number of pixels on each axis.<br/>

### Noise
White Noise Overlay. <br/>
**Noise Amp**: blends the noise with the original image.<br/>

### RGB Glitch
Displaces the red channel driven by a texture.<br/>
**RGB Offset**: displacement amount.<br/>
**RGB Offset Distortion Texture**: displacement texture.<br/>
**RGB Offset Speed**: speed of the animation.<br/>

### SampleStrip
Stretches pixels across a strip from two sides and interpolates between them.<br/>
**Sample Strip Size**: size of the strip.<br/>
**Sample Strip Direction**: direction of strip/movement (0 = left/right, 1 = top/down).<br/>
**Sample Strip Speed**: speed of the animation.<br/>

### Wobble
Distorts the picture around a circular mask.<br/>
**Wobble Amp**: amount of wobble.<br/>
**Wobble Speed**: speed of the animation.<br/>
**Wobble Distortion Texture**: displacement texture.<br/>

### Motion Blur
Blur around a circular mask.<br/>
**Motion Blur Amp**: amount of blur.<br/>

### Toon[^2][^3]
(Car)toon effect. <br/>
**Toon Num Colors**: number of colors.<br/>


## Sprite/UI Shaders[^4]
### Pixel 
*Same effect as the post processing shader.*<br/>
Pixelate Effect. <br/>
**Pixelate**: number of pixels on each axis.<br/>

### RGB Glitch
*Same effect as the post processing shader.*<br/>
Displaces the red channel driven by a texture.<br/>
**RGB Offset**: displacement amount.<br/>
**RGB Offset Distortion Texture**: displacement texture.<br/>
**RGB Offset Speed**: speed of the animation.<br/>


### SampleStrip
*Same effect as the post processing shader.*<br/>
Stretches pixels across a strip from two sides and interpolates between them.<br/>
**Sample Strip Size**: size of the strip.<br/>
**Sample Strip Direction**: direction of strip/movement (0 = left/right, 1 = top/down).<br/>
**Sample Strip Speed**: speed of the animation.<br/>


[^1]: Based on this [tutorial](https://www.alanzucconi.com/2015/07/08/screen-shaders-and-postprocessing-effects-in-unity3d/)
[^2]: Based on this [tutorial](https://www.chilliant.com/rgb2hsv.html)
[^3]: Based on this [tutorial](https://ragueel.medium.com/creating-simple-cell-shading-custom-post-process-in-hdrp-b3f2ea2b8c28)
[^4]: Based on this [tutorial](https://answers.unity.com/questions/583960/apply-shader-to-a-sprite.html)