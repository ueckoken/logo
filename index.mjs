import{Resvg,initWasm}from'@resvg/resvg-wasm';
import _wasm from'@resvg/resvg-wasm/index_bg.wasm';

await initWasm(_wasm);
const
render=async({svg,id,scale=2})=>((
	r=new Resvg(svg,{fitTo:{mode:'height',value:(svg.match(/<svg[^>]+height="(?<h>\d+?)"/)?.groups.h??256)*scale}}),
	view=svg.matchAll(/<view(?<attr>.*?)\/>/g)[Symbol.iterator]().reduce((a,{groups:{attr}})=>(
		attr=attr.matchAll(/(?<i>.+?)="(?<x>.*?)"/g)[Symbol.iterator]().reduce((a,{groups:{i,x}})=>(a[i.trim()]=x,a),{}),
		a[attr.id]=attr.viewBox.trim().split(' ').reduce((a,x,i)=>(a['x,y,width,height'.split(',')[i]]=+x,a),{}),
		a
	),{}),
	bbox=id&&view[id]
)=>(
	bbox&&r.cropByBBox(Object.assign(r.getBBox(),bbox)),
	r.render().asPng()
))();

export default{
	fetch:async(req,env,ctx)=>((
			url=new URL(req.url)
		)=>({
			'/logo.png':async _=>new Response(await render({svg:await(await env.ASSETS.fetch('https://a/logo.svg')).text(),id:url.search.slice(1)}))
		}[url.pathname]??(_=>env.ASSETS.fetch(req)))()
	)()
}
