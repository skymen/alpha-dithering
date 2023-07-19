/////////////////////////////////////////////////////////
// Minimal sample WebGPU shader. This just outputs a blue
// color to indicate WebGPU is in use (rather than one of
// the WebGL shader variants).

%%FRAGMENTINPUT_STRUCT%%
/* input struct contains the following fields:
fn c3_getBackUV(fragPos : vec2<f32>, texBack : texture_2d<f32>) -> vec2<f32>
fn c3_getDepthUV(fragPos : vec2<f32>, texDepth : texture_depth_2d) -> vec2<f32>
*/
%%FRAGMENTOUTPUT_STRUCT%%

%%SAMPLERFRONT_BINDING%% var samplerFront : sampler;
%%TEXTUREFRONT_BINDING%% var textureFront : texture_2d<f32>;

//%//%SAMPLERBACK_BINDING%//% var samplerBack : sampler;
//%//%TEXTUREBACK_BINDING%//% var textureBack : texture_2d<f32>;

//%//%SAMPLERDEPTH_BINDING%//% var samplerDepth : sampler;
//%//%TEXTUREDEPTH_BINDING%//% var textureDepth : texture_depth_2d;

struct ShaderParams {

	alphaDither : f32;
	scale : f32;

};

%%SHADERPARAMS_BINDING%% var<uniform> shaderParams : ShaderParams;


%%C3PARAMS_STRUCT%%
/* c3Params struct contains the following fields:
srcStart: vec2<f32>,
srcEnd: vec2<f32>,
srcOriginStart: vec2<f32>,
srcOriginEnd: vec2<f32>,
layoutStart: vec2<f32>,
layoutEnd: vec2<f32>,
destStart: vec2<f32>,
destEnd: vec2<f32>,
devicePixelRatio: f32,
layerScale: f32,
layerAngle: f32,
seconds: f32,
zNear: f32,
zFar: f32,
isSrcTexRotated: u32
*/
// + the following functions

/*
fn c3_srcToNorm(p : vec2<f32>) -> vec2<f32>
fn c3_normToSrc(p : vec2<f32>) -> vec2<f32>
fn c3_srcOriginToNorm(p : vec2<f32>) -> vec2<f32>
fn c3_normToSrcOrigin(p : vec2<f32>) -> vec2<f32>
fn c3_clampToSrc(p : vec2<f32>) -> vec2<f32>
fn c3_clampToSrcOrigin(p : vec2<f32>) -> vec2<f32>
fn c3_getLayoutPos(p : vec2<f32>) -> vec2<f32>
fn c3_srcToDest(p : vec2<f32>) -> vec2<f32>
fn c3_clampToDest(p : vec2<f32>) -> vec2<f32>
fn c3_linearizeDepth(depthSample : f32) -> f32
*/

//%//%C3_UTILITY_FUNCTIONS%//%
/*
fn c3_premultiply(c : vec4<f32>) -> vec4<f32>
fn c3_unpremultiply(c : vec4<f32>) -> vec4<f32>
fn c3_grayscale(rgb : vec3<f32>) -> f32
fn c3_getPixelSize(t : texture_2d<f32>) -> vec2<f32>
fn c3_RGBtoHSL(color : vec3<f32>) -> vec3<f32>
fn c3_HSLtoRGB(hsl : vec3<f32>) -> vec3<f32>
*/

var ptn1: mat4x4<f32> = mat4x4<f32>(
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 0.0,
    1.0, 0.0, 0.0, 0.0);

var ptn2: mat4x4<f32> = mat4x4<f32>(
		1.0, 0.0, 1.0, 0.0,
		0.0, 0.0, 0.0, 0.0,
		1.0, 0.0, 1.0, 0.0,
		0.0, 0.0, 0.0, 0.0);

var ptn3: mat4x4<f32> = mat4x4<f32>(
		0.0, 0.0, 1.0, 0.0,
		0.0, 1.0, 0.0, 1.0,
		1.0, 0.0, 0.0, 0.0,
		0.0, 1.0, 0.0, 1.0);

var ptn4: mat4x4<f32> = mat4x4<f32>(
		1.0, 0.0, 1.0, 0.0,
		0.0, 1.0, 0.0, 1.0,
		1.0, 0.0, 1.0, 0.0,
		0.0, 1.0, 0.0, 1.0);

var ptn5: mat4x4<f32> = mat4x4<f32>(
		1.0, 1.0, 0.0, 1.0,
		1.0, 0.0, 1.0, 0.0,
		0.0, 1.0, 1.0, 1.0,
		1.0, 0.0, 1.0, 0.0);

var ptn6: mat4x4<f32> = mat4x4<f32>(
		0.0, 1.0, 0.0, 1.0,
		1.0, 1.0, 1.0, 1.0,
		0.0, 1.0, 0.0, 1.0,
		1.0, 1.0, 1.0, 1.0);

var ptn7: mat4x4<f32> = mat4x4<f32>(
		1.0, 1.0, 1.0, 1.0,
		1.0, 1.0, 0.0, 1.0,
		1.0, 1.0, 1.0, 1.0,
		0.0, 1.0, 1.0, 1.0);

@fragment
fn main(input : FragmentInput) -> FragmentOutput
{
    var front: vec4<f32> = textureSample(textureFront, samplerFront, vTex);

    var srcOriginSize: vec2<f32> = c3Params.srcOriginEnd - c3Params.srcOriginStart;
    var n: vec2<f32> = (vTex - c3Params.srcOriginStart) / srcOriginSize;
    var l: vec2<f32> = mix(c3Params.layoutStart, c3Params.layoutEnd, n) - c3Params.layoutStart;
    var xy: vec2<f32> = l;

    var x: i32 = i32(modf(xy.x / shaderParams.scale, 4.0));
    var y: i32 = i32(modf(xy.y / shaderParams.scale, 4.0));

    var factor: f32 = 0.0;
    var pattern: i32 = i32(8.0 * shaderParams.alphaDither);

		if (pattern == 0) {factor = 0.0;}
		elseif (pattern == 1) {factor = ptn1[x][y];}
		elseif (pattern == 2) {factor = ptn2[x][y];}
		elseif (pattern == 3) {factor = ptn3[x][y];}
		elseif (pattern == 4) {factor = ptn4[x][y];}
		elseif (pattern == 5) {factor = ptn5[x][y];}
		elseif (pattern == 6) {factor = ptn6[x][y];}
		elseif (pattern == 7) {factor = ptn7[x][y];}
		elseif (pattern == 8) {factor = 1.0;}

    front *= factor;

    return front;
}
