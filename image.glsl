#version 150
out vec4 FragColor;

uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;
uniform samplerCube iChannel4;
uniform samplerCube iChannel5;
uniform samplerCube iChannel6;
uniform samplerCube iChannel7;
uniform vec4 iMouse;
uniform vec2 iResolution;
uniform float iTime;


float hash1(float x){
    return fract(sin(x)*43758.34); // 부동소숫점 오류, 곱하는 숫자는 Random Seed 처럼 쓸 수도 있음
}
float hash2(vec2 p){
    //return fract(sin(p.x*15.0 + p.y*35.7) * 43648.23); // 내적과 같음
    return fract(sin(dot(vec2(15.0, 35.7), p)) * 43648.23); // 마찬가지로 Random Seed 처럼 사용 가능
}
float hash3(vec3 p){
    return fract(sin(dot(vec3(15.0, 35.7, 58.2), p)) * 43648.23);
}

// Linear Interpolation
float noise(vec2 p){
    vec2 g = floor(p);
    vec2 f = fract(p);
    f = 3.0*f*f - 2.0*f*f*f; // cubic hermite spline, 3*x^2 - 2*x^3, hermite polymonals

    float lb = hash2(g + vec2(0.0, 0.0));
    float rb = hash2(g + vec2(1.0, 0.0));
    float lt = hash2(g + vec2(0.0, 1.0));
    float rt = hash2(g + vec2(1.0, 1.0));

    float b = mix(lb, rb, f.x);
    float t = mix(lt, rt, f.x);
    float res = mix(b, t, f.y);

    return res;
}

float noise3(vec3 p){
    vec3 g = floor(p);
    vec3 f = fract(p);
    f = 3.0*f*f - 2.0*f*f*f; // cubic hermite spline, 3*x^2 - 2*x^3, hermite polymonals

    float lbd = hash3(g + vec3(0.0, 0.0, 0.0));
    float rbd = hash3(g + vec3(1.0, 0.0, 0.0));
    float ltd = hash3(g + vec3(0.0, 1.0, 0.0));
    float rtd = hash3(g + vec3(1.0, 1.0, 0.0));

    float lbu = hash3(g + vec3(0.0, 0.0, 1.0));
    float rbu = hash3(g + vec3(1.0, 0.0, 1.0));
    float ltu = hash3(g + vec3(0.0, 1.0, 1.0));
    float rtu = hash3(g + vec3(1.0, 1.0, 1.0));

    float bd = mix(lbd, rbd, f.x);
    float td = mix(ltd, rtd, f.x);
    float d = mix(bd, td, f.y);

    float bu = mix(lbu, rbu, f.x);
    float tu = mix(ltu, rtu, f.x);
    float u = mix(bu, tu, f.y);

    float res = mix(d, u, f.z);

    return res;
}


float fBm(vec2 p){
    float res = 0.0;
    float theta = 3.141592 * 0.2; // 0.2PI, 계산할때마다 이만큼 회전?
    theta = 3.141592 + iTime*0.2;
    float c = cos(theta);
    float s = sin(theta);
    mat2 m = mat2(c, -s, s, c); // 회전행렬
    res += noise(p); p = m*p;
    res += noise(p*2.0); p = m*p;
    res += noise(p*3.0); p = m*p;
    res += noise(p*4.0); p = m*p;
    res += noise(p*5.0); p = m*p;
    res += noise(p*6.0); p = m*p;
    res /= 6.0;

    return res;
}

float fBm3(vec3 p){
    float res = 0.0;
    float theta = 3.141592 * 0.2;
    theta = 3.141592 + iTime*0.2;
    float c = cos(theta);
    float s = sin(theta);
    mat3 m = mat3(c, -s, s,
              c, 0.0, 0.0,
             0.0, 0.0, 0.0);
    res += noise3(p); p = m*p;
    res += noise3(p*2.0); p = m*p;
    res += noise3(p*3.0); p = m*p;
    res += noise3(p*4.0); p = m*p;
    res += noise3(p*5.0); p = m*p;
    res += noise3(p*6.0); p = m*p;
    res /= 6.0;

    return res;
}

vec2 hash2v(vec2 p){
    mat2 m = mat2(
        15.3, 36.3,
        75.8, 153.2
        );
    return fract(sin(m*p) * 43648.23); // 내적을 2번한 꼴 , ax + by = x', cx + dy = y'
}

float voronoi(vec2 p){
    vec2 g = floor(p);
    vec2 f = fract(p);

    float res = 8.0;
    for(int y = -1; y <= 1; y++){
        for(int x = -1; x <= 1; x++){
            vec2 b = vec2(x, y); // x,y,z에 -1~1까지 9개 값이 나온다
            float h = distance(hash2v(g + b) + b, f);
            res = min(res, h);
        }
    }

    return res;
}


float smin(float a, float b, float k){
    float h = clamp((b-a)/k*0.5+0.5, 0.,1.);
    return mix(b,a,h) - k*h*(1. -h);
}

float sdPlane(vec3 p){
    //return p.y + noise(p.xz*2.0)*0.2;
    return p.y - voronoi(p.xz*1.0)*0.2;
}

float sdSphere(vec3 p){
    return length(p)-0.5;// + noise3(p * 15.0 + iTime) * 0.02;
}

float map(vec3 p){
    vec3 q = mod(p*1.0, 2.5) -1.0;// + vec3(0.0, -0.8, 0.0);

    //float d = length(p) - 0.5 + fBm(p.xy*5.0) * 0.1;
    //float d = length(p) - 0.5 + noise3(p*10.0) * 0.1;
    //float d = length(p) - 0.5 + fBm3(p*15.0) * 0.1;
    float d = sdPlane(p - vec3(0.0+iTime, -0.4, 0.0));
    //d = min(d, sdSphere(p));
    //d = smin(d, sdSphere(q), 0.8);
    //float d = sdSphere(q);
    return d;
}

vec3 calcNormal(vec3 p){
    vec2 e = vec2(0.0001, 0.0);
    vec3 nor = vec3(
        map(p+e.xyy) - map(p-e.xyy),
        map(p+e.yxy) - map(p-e.yxy),
        map(p+e.yyx) - map(p-e.yyx)
    );
    return normalize(nor);
}



void main( void ) {
    vec2 p = ( gl_FragCoord.xy / iResolution.xy );
    //p = fract(p*2.0);
    p = p*2.0-1.0;
    p.x *= iResolution.x/iResolution.y;

    float tt = iTime*5.0;
    tt = sin(iTime*3.0)*5.0-5.5;
    vec3 ro = vec3(0.0, -0.0 + sin(iTime*5.0)*0.1, 3.0 - tt);
    ro = vec3(cos(iTime)*5.0, 0.0, sin(iTime)*5.0);
    vec3 center = vec3(0.0, 0.0, 0.0);
    vec3 cw = normalize(center - ro);
    vec3 up = vec3(0.0, 1.0, 0.0);
    vec3 cu = normalize(cross(cw, up));
    vec3 cv = normalize(cross(cu, cw));

    vec3 rd = normalize(p.x*cu + p.y*cv + 2.5*cw);


    float e = 0.0001;
    float t = 0.0;
    float h = e * 2.0;
    for(int i=0; i<60; i++){
        if(h<e || t>20.0) continue;
        h = map(ro + rd * t);
        t+=h;
    }

    float col = 1.0-length(p);
    vec3 cc = vec3(0.0);
    cc = (1.0-length(p)) * vec3(0.5, 0.2, 0.4);
    if(t<20.0){
        vec3 pos = ro+rd*t;
        vec3 lig = normalize(vec3(1.0));
        vec3 nor = calcNormal(pos);
        float NL = max(0.0, dot(nor, lig));
        col = NL;// + pos.y*0.5;
        //col = t/5.0; // like DepthMap
        cc = vec3(col*0.7, 0.1, col*0.3);
        //cc += pos.y*vec3(0.0,0.0,0.2);
        float NV = max(0.0, dot(nor, rd));
        NV = 1.0-NV;
        NV = NV*NV*NV*NV*NV*NV;
        cc *= NV;
    }

    FragColor = vec4( cc + ((1.0-length(p))*vec3(0.0, 0.05, 0.01)), 1.0 );
}