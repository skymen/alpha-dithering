#version 300 es

precision lowp float;
precision mediump int;

in vec2 vTex;
out vec4 outColor;

uniform lowp float alphaDither;
uniform lowp float scale;
uniform lowp sampler2D samplerFront;
uniform vec2 srcOriginStart;
uniform vec2 srcOriginEnd;
uniform vec2 layoutStart;
uniform vec2 layoutEnd;

const mediump mat4 ptn1 = mat4(0.0, 0.0, 0.0, 0.0,
							   0.0, 0.0, 1.0, 0.0,
							   0.0, 0.0, 0.0, 0.0,
							   1.0, 0.0, 0.0, 0.0);

const mediump mat4 ptn2 = mat4(1.0, 0.0, 1.0, 0.0,
							   0.0, 0.0, 0.0, 0.0,
							   1.0, 0.0, 1.0, 0.0,
							   0.0, 0.0, 0.0, 0.0);

const mediump mat4 ptn3 = mat4(0.0, 0.0, 1.0, 0.0,
							   0.0, 1.0, 0.0, 1.0,
							   1.0, 0.0, 0.0, 0.0,
							   0.0, 1.0, 0.0, 1.0);

const mediump mat4 ptn4 = mat4(1.0, 0.0, 1.0, 0.0,
						   	   0.0, 1.0, 0.0, 1.0,
							   1.0, 0.0, 1.0, 0.0,
							   0.0, 1.0, 0.0, 1.0);

const mediump mat4 ptn5 = mat4(1.0, 1.0, 0.0, 1.0,
							   1.0, 0.0, 1.0, 0.0,
							   0.0, 1.0, 1.0, 1.0,
							   1.0, 0.0, 1.0, 0.0);

const mediump mat4 ptn6 = mat4(0.0, 1.0, 0.0, 1.0,
							   1.0, 1.0, 1.0, 1.0,
							   0.0, 1.0, 0.0, 1.0,
							   1.0, 1.0, 1.0, 1.0);

const mediump mat4 ptn7 = mat4(1.0, 1.0, 1.0, 1.0,
							   1.0, 1.0, 0.0, 1.0,
							   1.0, 1.0, 1.0, 1.0,
							   0.0, 1.0, 1.0, 1.0);

void main(void)
{
    vec4 front = texture(samplerFront, vTex);

    vec2 srcOriginSize = srcOriginEnd - srcOriginStart;
    vec2 n = (vTex - srcOriginStart) / srcOriginSize;
    vec2 l = mix(layoutStart, layoutEnd, n) - layoutStart;
    vec2 xy = l;

    int x = int(mod(xy.x / scale, 4.0));
    int y = int(mod(xy.y / scale, 4.0));

    float factor = 0.0;
    int pattern = int(8.0 * alphaDither);

    if (pattern == 0) factor = 0.0;
    else if (pattern == 1) factor = ptn1[x][y];
    else if (pattern == 2) factor = ptn2[x][y];
    else if (pattern == 3) factor = ptn3[x][y];
    else if (pattern == 4) factor = ptn4[x][y];
    else if (pattern == 5) factor = ptn5[x][y];
    else if (pattern == 6) factor = ptn6[x][y];
    else if (pattern == 7) factor = ptn7[x][y];
    else if (pattern == 8) factor = 1.0;

    front *= factor;

    outColor = front;
}
