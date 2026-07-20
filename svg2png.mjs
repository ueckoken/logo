#!/usr/bin/env -S bun --install=force
import{renderAsync}from'@resvg/resvg-js';

await[...new Bun.Glob('**/*.svg').scanSync('.')].reduce(async(a,x)=>(
	await a,
	console.log(x),
	await Bun.write(
		`${x}.png`,
		(await renderAsync(
			await Bun.file(x).text(),
			{fitTo:{mode:'zoom',value:2}}
		)).asPng()
	)
),0);
