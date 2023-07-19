uniform lowp float alphaDither;
uniform lowp float scale;
varying mediump vec2 vTex;
uniform lowp sampler2D samplerFront;
uniform mediump vec2 srcOriginStart;
uniform mediump vec2 srcOriginEnd;
uniform mediump vec2 layoutStart;
uniform mediump vec2 layoutEnd;

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


mediump float fetchFactor(mediump mat4 matrix, mediump int x, mediump int y)
{
	if (x == 0)
	{
		if (y == 0) return matrix[0][0];
		if (y == 1) return matrix[0][1];
		if (y == 2) return matrix[0][2];
		if (y == 3) return matrix[0][3];
	}
	if (x == 1)
	{
		if (y == 0) return matrix[1][0];
		if (y == 1) return matrix[1][1];
		if (y == 2) return matrix[1][2];
		if (y == 3) return matrix[1][3];
	}
	if (x == 2)
	{
		if (y == 0) return matrix[2][0];
		if (y == 1) return matrix[2][1];
		if (y == 2) return matrix[2][2];
		if (y == 3) return matrix[2][3];
	}
	if (x == 3)
	{
		if (y == 0) return matrix[3][0];
		if (y == 1) return matrix[3][1];
		if (y == 2) return matrix[3][2];
		if (y == 3) return matrix[3][3];
	}
}

void main(void)
{
	mediump vec4 front = texture2D(samplerFront, vTex);

  mediump vec2 srcOriginSize = srcOriginEnd - srcOriginStart;
	mediump vec2 n = (vTex - srcOriginStart) / srcOriginSize;
	mediump vec2 l = mix(layoutStart, layoutEnd, n) - layoutStart;
	mediump vec2 xy = l;

  mediump int x = int(mod(xy.x / scale, 4.0));
  mediump int y = int(mod(xy.y / scale, 4.0));

	mediump float factor = 0.0;
	mediump int pattern = int(8.0 * alphaDither);

	if (pattern == 0) factor = 0.0;
	else if (pattern == 1) factor = fetchFactor(ptn1, x, y);
	else if (pattern == 2) factor = fetchFactor(ptn2, x, y);
	else if (pattern == 3) factor = fetchFactor(ptn3, x, y);
	else if (pattern == 4) factor = fetchFactor(ptn4, x, y);
	else if (pattern == 5) factor = fetchFactor(ptn5, x, y);
	else if (pattern == 6) factor = fetchFactor(ptn6, x, y);
	else if (pattern == 7) factor = fetchFactor(ptn7, x, y);
	else if (pattern == 8) factor = 1.0;

	front *= factor;

	gl_FragColor = front;
}