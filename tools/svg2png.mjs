#!/usr/bin/env -S bun --install=force
import{renderAsync,Resvg}from'@resvg/resvg-js';

await[...new Bun.Glob('**/logo.svg').scanSync({followSymlinks:true})].reduce(async(a,x,s)=>(
	await a,
	console.log(x),
	s=await Bun.file(x).text(),
	await s.matchAll(/(?:id="(?<i>.+?)".*)?viewBox="(?<b>[\d\s]+)"/g).map(({groups:{i,b}})=>({i,b:b.split(' ').map(x=>+x)})).reduce(async(a,{i,b,r})=>(
		await a,
		r=new Resvg(s,{fitTo:{mode:'height',value:+s.match(/height="(?<h>\d+?)"/)?.groups.h*2??256}}),
		r.cropByBBox(b.reduce((a,x,i)=>(a['x,y,width,height'.split(',')[i]]=x,a),r.getBBox())),
		i&&console.log(`#${i}`),
		await Bun.write(
			`${x}.png/${x.split('/').pop()}${i?`#${i}`:''}.png`,
			// (await renderAsync(
			// 	s,
			// 	{
			// 		crop:{left:b[0],top:b[1],right:b[0]+b[2],bottom:b[1]+b[3]},
			// 		fitTo:{mode:'zoom',value:2}
			// 	}
			// )).asPng()
			r.render().asPng()
		)
	),0)
	// await Bun.write(
	// 	`${x}.png`,
	// 	(await renderAsync(
	// 		s,
	// 		{fitTo:{mode:'zoom',value:2}}
	// 	)).asPng()
	// )
),0);
