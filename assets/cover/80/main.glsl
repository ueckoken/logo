// https://mcbeeringi.github.io/apps/webgl/fsh.html
// a5 600dpi +nuritashi [3638,5102]
// put picture to tex0

precision highp float;
uniform float time;
uniform vec2 res;
uniform sampler2D tex0;
uniform vec2 tex0res;

const float bg_noise_intensity=0.005;// 0~1
const float reflact_intensity=.025;// 0~
const float chroma_abr_intensity=.01;// 0~reflact_intensity
const float radius=.333;// 0~1




const float PI=3.141592653;

#define U(A,B) smin(A,B,x)
#define L(AX,AY,BX,BY) line(p,vec3(AX,AY,0),vec3(BX,BY,0),.5)
#define A(OX,OY,R,A0,A1) _A(p,vec2(OX,OY),float(R),vec2(A0,A1),.5)

// https://www.shadertoy.com/view/4djSRW
vec2 hash22(vec2 p){
	vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx+33.33);
	return fract((p3.xx+p3.yz)*p3.zy);
}

// https://iquilezles.org/articles/distfunctions/
float arc(vec3 p,vec2 sc,float ra,float rb){
	p.x=abs(p.x);
	float k=(sc.y*p.x>sc.x*p.y)?dot(p.xy,sc):length(p.xy);
	return sqrt(dot(p,p)+ra*ra-2.*ra*k)-rb;
}
float line(vec3 p,vec3 a,vec3 b,float r){
	vec3 pa=p-a,ba=b-a;
	float h=clamp(dot(pa,ba)/dot(ba,ba),0.,1.);
	return length(pa-ba*h)-r;
}
float _A(vec3 _p,vec2 o,float ra,vec2 a,float rb){
	float amean=dot(a,vec2(.5))-PI*.5;
	float adiff=min(abs(dot(a,vec2(-1,1)))*.5,2.*PI);
	vec4 p=mat4(
			cos(amean),-sin(amean),0,0,
			sin(amean),cos(amean),0,0,
			0,0,1,0,
			0,0,0,1
		)*mat4(
			1,0,0,0,
			0,1,0,0,
			0,0,1,0,
			-o.x,-o.y,0,1
		)*vec4(_p,1);
	return arc(p.xyz,vec2(sin(adiff),cos(adiff)),ra,rb);
}

// https://iquilezles.org/articles/smin/
// circular
float smin(float a,float b,float k){
	k*=1./(1.-sqrt(.5));
	float h=max(k-abs(a-b),0.)/k;
	return min(a,b)-k*.5*(1.+h-sqrt(1.-h*(h-2.)));
}

float kai(vec3 a){return(-a.y+sqrt(a.y*a.y-4.*a.x*a.z))/a.x*.5;}
float cl(float r){return kai(vec3(1.0625,-.125,.0625-r*r));}


float logo(vec3 _p,float x){
	vec3 p=(mat4(
		1, 0,0,0,
		0,-1,0,0,
		0, 0,1,0,
		0, 1,0,0
	)*vec4(_p,1)).xyz*20.;
	
	return
	U(
		U(
			U(
				U(
					L(-2,7,9,4.25),
					L(6,5,6,10)
				),U(
					L(2,11,13,8.25),L(14,8,18,7)
				)
			),
			U(
				U(
					L(14,11,22,9),
					U(U(
						L(11,14.75,13,14.25),
						L(13,14.25,13,11.25)
					),U(
						L(13,11.25,11,11.75),
						L(11,11.75,11,16)
					))
				),
				L(17,7.25,17,22)
			)
		),
		U(
			A(5,10,6,-acos(cl(6.)/6.),acos(4./6.)),
			A(5,10,10,-acos(cl(10.)/10.),asin(5./10.))
		)
	);
}

void main(){
	vec3 p=vec3(
		(
			((gl_FragCoord.xy/res-.5)/.9+.5)*res+(res.yx-res.xy)*step(res.yx,res.xy)*.5
		)/min(res.x,res.y),
		.001

	);
	float t=0.;

	float d=clamp(-logo(p,t)*2./radius,0.,PI/2.);
	float b=smoothstep(0.,.2,d);
	float bi=1.-b;
	float cd=cos(d);
	float cdb=cd*b;
	float sd=sin(d);
	vec2 n=normalize(vec2(
		logo(p,t)-logo(p+vec3(.01,0,0),t),
		logo(p,t)-logo(p+vec3(0,.01,0),t)
	));

	vec2 texp=(
		gl_FragCoord.xy/res-.5
	)*(
		res/(tex0res*max(res.x/tex0res.x,res.y/tex0res.y))
	)+.5;
	vec2 noise=(hash22(texp*1024.)-.5)*bg_noise_intensity;

	gl_FragColor=vec4(
		//mix(
		(
			vec3(
				texture2D(tex0,texp+noise*bi+(n*cdb)*(reflact_intensity-chroma_abr_intensity)).r,
				texture2D(tex0,texp+noise*bi+(n*cdb)*(reflact_intensity)).g,
				texture2D(tex0,texp+noise*bi+(n*cdb)*(reflact_intensity+chroma_abr_intensity)).b
			)+
			vec3(1)*
			//vec3(3,.2,.4)/3.,
			sd*.5
		),
		1
	);
}


