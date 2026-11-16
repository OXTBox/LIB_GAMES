
arcadeFont={{"Invader","siSi"},{"Blast","9o"},{"Xaxon","Zz"},{"Vermin","v"},{"RightShip","O"},{"VerticalShip","cIGR"},{"RightSnake","N"},{"Ghost","X"},{"Gorilla","U"},{"Turtle","f"},{"Galaxian","g"},{"Agent","e"},{"GridBug","t"},{"Tron","T"},{"Dragon","D"},{"Monkey","k"},{"Man","E"},{"Mario","u"},{"Elf","m"},{"Bike","j"},{"Archer","V"},{"Dragon","w"} };

cycletime=os.time()
cyclerate=0
cycledchar=1
cycleString=""
cycleWidth=1
textDirections={}
for i = 1,24 do table.insert(textDirections,64) end

textDrop=64
function textArcade(n,cycledchar)
if n == nil then n = #arcadeFont end
if cycledchar == nil then cycledchar = 1 end
arctext=arcadeFont[n][2]
if cycledchar > string.len(arctext)+1 then cycledchar = 1  end
arctext=string.sub(arctext,cycledchar,cycledchar)
return arctext
end


function cycleArcade(box,n,r,cw)
if box == nil then box = 1 end
if n == nil then n = 1 end
if r == nil then r = 40 end
if cw == nil then cw = 10 end
cyclerate=cyclerate+1

	if cyclerate > r then	
	--print(cyclerate)
	cyclerate = 0
	cycledchar = cycledchar + 1
	arctext=arcadeFont[n][2]
	if cycledchar > string.len(arctext) then cycledchar = 1  end
	cycleString=textArcade(n,cycledchar)	
	end
	ps = passed()
	local size,x,y,r,g,b,a,font,text = ig3d_GetTextboxInfo_i_3i4f2s(box)
	if textDirections[box] == nil then textDirections[box]=64 end
		l,t,rt,b=ig3d_GetWindowBounds__4i()
		yc=0
		boxloc=((box/24)/3)*size
		x=x+textDirections[box]
		if x > (size*8)+1 then 
		x=((box/24)/3)*size
		yc = 1
		end
			y=y+yc
		if y> (size*6)+1 then
		x=((box/24)/3)*size
			y = 1
		end
		ig3d_SetTextboxInfo_4i4f2s(box,size,x,y,r,g,b,a,font,cycleString)

	
	


end
bnum=0
function invaders()
if bnum + 1 > gNumTextboxes/8 then bnum = 0 end
bnum = bnum + 1

cycleArcade(bnum,1,1)
cycleArcade(bnum+8,1,1)
cycleArcade(bnum+16,1,1)
end

function randomtext(n,w,ls,le)

	if w == nil then w = 40 end;
	if n == nil then n = 256 end;
	wc = 0
	newText=""
	theText = ""
	for i =1,n  do
		wc = wc + 1
		

			if wc > w then 
				print(theText)
				theText = "" 
				wc =0
			end

			if ls == nil then ls = 1 end
			if le == nil then le = 128 end
		
			newByte = math.random(ls,le)
			newText = string.char(newByte)
			theText =theText .. newText
	end
end


function allchar()
txt=""
wc=0
for i = 1,128 do
wc=wc + 1

	if wc > 40 then 
	print(txt)
	txt=""
	wc = 0
	end
txt=txt..string.char(i)

end
end

