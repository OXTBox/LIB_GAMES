gMaxAStarPasses=0


-- Tobi's attempt of making Lua classes for lists and binary heaps
SimpleList = { list={ }}
SimpleList_mt = { __index = SimpleList }

function SimpleList:create()
	local new_inst={}
	setmetatable(new_inst, SimpleList_mt)
	return new_inst
end


function SimpleList:add(node)
	node.icl=true --in closed list = true
	table.insert(self.list, node)
end

function SimpleList:isEmpty()
	return #self.list == 0
end

function SimpleList:contains( what )
	return what.icl
end

function SimpleList:cleanup()
	local i
	for i=#self.list,1,-1 do
		self.list[i].heapEntry=nil
		self.list[i].icl=false
		table.remove(self.list)
	end	
end


SimpleMinHeap = { heap={} }
SimpleMinHeap_mt = { __index = SimpleMinHeap }

function SimpleMinHeap:create()
	local new_inst={}
	setmetatable(new_inst, SimpleMinHeap_mt)
	return new_inst
end


function SimpleMinHeap:insert(node, prio)
	table.insert(self.heap, {nd=node, f=prio})
	node.heapEntry=self.heap[#self.heap]
	self:heapify(#self.heap)
end

function SimpleMinHeap:extractMin()
	if #self.heap==0 then return nil end
	local mn=self.heap[1]
	self.heap[1]=self.heap[#self.heap]
	table.remove(self.heap)
	self:heapify(1)
	return mn.nd
end

function SimpleMinHeap:heapify(idx)
	if #self.heap == 0 then return end
	--phase 1
	while true do
		if idx==1 then
			break
		else
			local prnt
			if idx % 2 == 1 then prnt= (idx-1)/2 else prnt=idx/2 end
			
			if self.heap[idx].f < self.heap[prnt].f then
				local swp=self.heap[prnt]
				self.heap[prnt]=self.heap[idx]
				self.heap[idx]=swp
				idx=prnt
			else
				break
			end
		end
	end
	--phase 2
	while true do
		if idx*2 > #self.heap then 
			--ie has no children
			break 
		else
			--check children
			local smallestKid=idx*2
			if smallestKid+1 <= #self.heap then
				if self.heap[smallestKid+1].f<self.heap[smallestKid].f then
					smallestKid=smallestKid+1
				end
			end
			if self.heap[idx].f>self.heap[smallestKid].f then
				local swp=self.heap[smallestKid]
				self.heap[smallestKid]=self.heap[idx]
				self.heap[idx]=swp
				idx=smallestKid
			else
				break
			end
		end
	end
end

function SimpleMinHeap:contains( what )
	return what.heapEntry~= nil
end


function SimpleMinHeap:changeKey( what, val )
	local i
	for i=1,#self.heap,1 do
		if self.heap[i].nd==what then
			self.heap[i].f=val
			self:heapify(i)
			break
		end
	end	
end

function SimpleMinHeap:isEmpty()
	return #self.heap == 0
end

function SimpleMinHeap:cleanup()
	local i
	for i=#self.heap,1,-1 do
		self.heap[i].nd.icl=false
		self.heap[i].nd.heapEntry=nil
		table.remove(self.heap)
	end	
end



function pointInObjectBoundingBox(obj, x,y,z)
	--have to rotate the position into the object's local coordinate system, then check if it is within the oriented bounding box
	local sx,bx,sy,by,sz,bz=getObjectInfo(obj.cObj, IG3D_BOUNDS)
	local a11,a12,a13,a14, a21,a22,a23,a24, a31,a32,a33,a34, a41,a42,a43,a44=getObjectInfo(obj.cObj, IG3D_ROTATION_MATRIX)
	x=x-a41
	y=y-a42
	z=z-a43

	local tx=x*a11 + y*a12 + z*a13
	local ty=x*a21 + y*a22 + z*a23
	local tz=x*a31 + y*a32 + z*a33

	--if tx>sx and tx<bx and ty>sy and ty<by and tz>sz and tz<bz then return true end
	if tx>sx and tx<bx and tz>sz and tz<bz then return true end
	return false
end



NoPathFound=0
PathFound=1


function a_star(startNode, destinationNode)
    -- Initialisierung der Open List, die Closed List ist noch leer
    -- (die Priorität bzw. der f Wert des Startknotens ist unerheblich)
	openlist=SimpleMinHeap:create()
	openlist:insert(startNode,0)
	closedlist=SimpleList:create()

    -- diese Schleife wird durchlaufen bis entweder
    -- - die optimale Lösung gefunden wurde oder
    -- - feststeht, dass keine Lösung existiert


    while true do
        -- Knoten mit dem geringsten f Wert aus der Open List entfernen
        currentNode = openlist:extractMin()
        -- wurde das Ziel gefunden?
        if currentNode == destinationNode then
        	destinationNode.heapEntry=nil--IMPORTANT for cleanup
        	openlist:cleanup()
        	closedlist:cleanup()
            return PathFound
		end
        -- Nachfolgeknoten auf die Open List setzen
        
		expandNode(currentNode)

        -- der aktuelle Knoten ist nun abschließend untersucht
        closedlist:add(currentNode)
    	if openlist:isEmpty() then break end
    end
    -- die Open List ist leer, es existiert kein Pfad zum Ziel
    openlist:cleanup()
    closedlist:cleanup()
    return NoPathFound
end


function squareOf(x)
	return x*x
end

function astar_g(node)
	if node.heapEntry~= nil then
		return node.heapEntry.f
	else
		return 0
	end
end



function astar_c(node1,node2,i)
	
	--return math.sqrt(squareOf(node1.x-node2.x)+squareOf(node1.y-node2.y)+squareOf(node1.z-node2.z)) --maybe dont need to use the square root
	return math.sqrt(squareOf(node1.x-node2.x)+squareOf(node1.z-node2.z)) --maybe dont need to use the square root

	--if i<= 4 then return gGridSize else return gGridSize*1.414214 end
	--straight or diagonal move
end

function astar_h(node)
	--return math.sqrt(squareOf(node.x-destinationNode.x)+squareOf(node.y-destinationNode.y)+squareOf(node.z-destinationNode.z))
	return math.sqrt(squareOf(node.x-destinationNode.x)+squareOf(node.z-destinationNode.z))
end


function expandNode(currentNode)
    local i
    	
    	--reason for outcommenting: no dynamic change of node flags
     flagNode(currentNode)--wow, time intensiv!!
    
	for i=1,#currentNode.successors,1 do
		
		local successor=currentNode.successors[i]
        	-- wenn der Nachfolgeknoten bereits auf der Closed List ist - tue nichts
        
        
							
        --Update state of node:
        --reason for outcommenting: no dynamic change of node flags
        flagNode(successor)--wow, time intensiv!!
        --That node is obstructed----
       	if currentNode.inside==false and successor.inside==true then
        	--closedlist:add(successor)
        end
        -----------------------------
        
		if not closedlist:contains(successor) then
			
      			-- f Wert fr den neuen Weg berechnen: g Wert des Vorgngers plus die Kosten der
        		-- gerade benutzten Kante plus die geschtzten Kosten von Nachfolger bis Ziel
        		f = astar_g(currentNode) + astar_c(currentNode, successor, i) + astar_h(successor)
			-- wenn der Nachfolgeknoten bereits auf der Open List ist,
        		-- aber der neue Weg lnger ist als der alte - tue nichts
        		
			if not openlist:contains(successor) or f <= successor.heapEntry.f then
            			
            		
        			-- Vorgängerzeiger setzen
        			successor.predecessor = currentNode
				
        			-- f Wert des Knotens in der Open List aktualisieren
        			-- bzw. Knoten mit f Wert in die Open List einfgen
        			if openlist:contains(successor) then
         	   			openlist:changeKey(successor, f)
        			else
         	   			openlist:insert(successor, f)
    				end
				
			end
			
		end
		
	end
end




function pick_best_matching_floor(node, y)
	local i
	local k=1
	local theAbs=10000.0
	
	for i=1,#node,1 do
		if math.abs(node[i].y-y)<theAbs then
			theAbs=math.abs(node[i].y-y)
			k=i
		end
	end

	return node[k]
end


function maybe_add_successor_primitive_nodes(node1, node2)
	local toTheSideConst=0.31
	
	if node1.inside==true or node2.inside== true then return end --probably scenery
	--if node2.y-node1.y > 0.5 then return end --high step
	
	if lineCollision(node1.x,node1.y+0.1,node1.z, node2.x, node2.y+0.1, node2.z, true) then
		return
	end
	
	local dx=node2.x-node1.x
	local dy=node2.y-node1.y
	local dz=node2.z-node1.z
	dx,dy,dz=normalized(dx,dy,dz)
	dx,dy,dz=cross(dx,dy,dz, 0,1,0)
	
	if lineCollision(node1.x-dx* toTheSideConst,node1.y-dy* toTheSideConst +0.1,node1.z-dz* toTheSideConst, node2.x-dx* toTheSideConst, node2.y-dy* toTheSideConst +0.1, node2.z-dz* toTheSideConst, true) then
		return
	end
	
	if lineCollision(node1.x+dx* toTheSideConst,node1.y+dy* toTheSideConst +0.1,node1.z+dz* toTheSideConst, node2.x+dx* toTheSideConst, node2.y+dy* toTheSideConst +0.1, node2.z+dz* toTheSideConst, true) then
		return
	end
	
	if node2.y-node1.y > 0.25 then return end --bad
	
	table.insert(node1.successors, node2)
end


function maybe_add_successor(nodes1, nodes2)
	local i,j
	
	for i=1,#nodes1,1 do
		for j=1,#nodes2,1 do
			maybe_add_successor_primitive_nodes(nodes1[i],nodes2[j])
		end
	end
	
end


--big change, this is 3D-table now, since there might be multiple floors at a certain 2D-position
function createNodeGrid(xsize,zsize,xoffset,zoffset,gridsize)
	grid={}
	
	for i=1,xsize,1 do
		a={}
		for j=1,zsize,1 do
		
			local prx=i*gridsize+xoffset
			local pry=200
			local prz=j*gridsize+zoffset
			
			local c=1
			local x,y,z,o
			local floors={}
			while c>0 do
				c,x,y,z,o=lineCollision(prx,pry-0.1,prz,prx,pry-200,prz)
				if y<-0.2 then break end
				if c~= 0 then
					pry=y
					table.insert(floors, {name=i..","..j..","..(#floors+1), x=prx, y=pry+0.05, z=prz, successors={}, icl=false, heapEntry=nil})
					flagNode(floors[#floors])
				end
				
			end			
			
			
			if #floors == 0 then
				table.insert(floors, {name=i..","..j..","..(#floors+1), x=prx, y=250, z=prz, successors={}, icl=false, heapEntry=nil})
				flagNode(floors[#floors])
			end
			
			table.insert(a, floors)
		end
		table.insert(grid, a)
	end

	for i=1,xsize,1 do
		for j=1,zsize,1 do
			if i<xsize then maybe_add_successor(grid[i][j], grid[i+1][j]) end--1
			if i<xsize and j>1 then maybe_add_successor(grid[i][j], grid[i+1][j-1]) end--6
			if j>1 then maybe_add_successor(grid[i][j], grid[i][j-1]) end--4
			if i>1 and j>1 then maybe_add_successor(grid[i][j], grid[i-1][j-1]) end--8
			if i>1 then maybe_add_successor(grid[i][j], grid[i-1][j]) end--3
			if i>1 and j<zsize then maybe_add_successor(grid[i][j], grid[i-1][j+1]) end--7
			if j<zsize then maybe_add_successor(grid[i][j], grid[i][j+1]) end--2
			if i<xsize and j<zsize then maybe_add_successor(grid[i][j], grid[i+1][j+1]) end--5
		end
	end
	
end




function getNearestNodeOfPosition(x,y,z)
	local i=math.min( math.max(math.floor((x-gXOffset)/gGridSize),1), gNumRowVertices)
	local j=math.min( math.max(math.floor((z-gZOffset)/gGridSize),1), gNumColumnVertices)
	
	local mindst=vecLength(grid[i][j][1].x-x, 0, grid[i][j][1].z-z)
	local dst
	local compNode
	local theNode= pick_best_matching_floor( grid[i][j], y)
	
	i=math.min( math.max(math.floor((x-gXOffset)/gGridSize),1), gNumRowVertices)
	j=math.min( math.max(math.ceil((z-gZOffset)/gGridSize),1), gNumColumnVertices)
	compNode=pick_best_matching_floor( grid[i][j], y)
	dst=vecLength(compNode.x-x, 0, compNode.z-z)
	if dst<mindst then
		mindst=dst
		theNode=compNode
	end

	i=math.min( math.max(math.ceil((x-gXOffset)/gGridSize),1), gNumRowVertices)
	j=math.min( math.max(math.floor((z-gZOffset)/gGridSize),1), gNumColumnVertices)
	compNode=pick_best_matching_floor( grid[i][j], y)
	dst=vecLength(compNode.x-x, 0, compNode.z-z)
	if dst<mindst then
		mindst=dst
		theNode=compNode
	end
	
	i=math.min( math.max(math.ceil((x-gXOffset)/gGridSize),1), gNumRowVertices)
	j=math.min( math.max(math.ceil((z-gZOffset)/gGridSize),1), gNumColumnVertices)
	compNode=pick_best_matching_floor( grid[i][j], y)
	dst=vecLength(compNode.x-x, 0, compNode.z-z)
	if dst<mindst then
		mindst=dst
		theNode=compNode
	end
	
	return theNode
end

function getSurroundingNodesOfPosition(x,y,z)
	local nodes={}
	
	local i=math.min( math.max(math.floor((x-gXOffset)/gGridSize),1), gNumRowVertices)
	local j=math.min( math.max(math.floor((z-gZOffset)/gGridSize),1), gNumColumnVertices)
	table.insert(nodes, pick_best_matching_floor(grid[i][j],y) )
	
	local i=math.min( math.max(math.floor((x-gXOffset)/gGridSize),1), gNumRowVertices)
	local j=math.min( math.max(math.ceil((z-gZOffset)/gGridSize),1), gNumColumnVertices)
	table.insert(nodes, pick_best_matching_floor(grid[i][j],y) )

	local i=math.min( math.max(math.ceil((x-gXOffset)/gGridSize),1), gNumRowVertices)
	local j=math.min( math.max(math.floor((z-gZOffset)/gGridSize),1), gNumColumnVertices)
	table.insert(nodes, pick_best_matching_floor(grid[i][j],y) )
	
	local i=math.min( math.max(math.ceil((x-gXOffset)/gGridSize),1), gNumRowVertices)
	local j=math.min( math.max(math.ceil((z-gZOffset)/gGridSize),1), gNumColumnVertices)
	table.insert(nodes, pick_best_matching_floor(grid[i][j],y) )
	
	return nodes
end

function flagNode(nd)

	if nd.flagTime==nil or time()-nd.flagTime > 3.0 then --reflag nodes only every three seconds if possible
		nd.flagTime=time()
		nd.inside=false
		
		--if nd.y>2 then nd.inside=true end
		
		for i=1,gNumObjects,1 do
			local blockingObject=false
			
			--if gObjects[i].selected==true then
			--	blockingObject=false
			--end
			
			--if gObjects[i].driver~= nil and gObjects[i].driver.selected==true then blockingObject=false end
			
			if gObjects[i].team==9 then
				blockingObject=true --reenable if there is scenery
			end
			
			
			if blockingObject then
				--[[
				local x,y,z=getObjectInfo(gObjects[i].cObj, IG3D_POSITION)
				local xlow,xhigh,ylow,yhigh,zlow,zhigh=getObjectInfo(gObjects[i].cObj, IG3D_BOUNDS)

				local maxsidehalf=math.max(xhigh-xlow, zhigh-zlow)*0.5
				xlow=x-maxsidehalf---0.5
				xhigh=x+ maxsidehalf-- +0.5
				zlow=z-maxsidehalf---0.5
				zhigh=z+ maxsidehalf --+0.5
				if nd.x>xlow and nd.x<xhigh and nd.z>zlow and nd.z<zhigh then nd.inside=true; return; end
				--]]
				if pointInObjectBoundingBox(gObjects[i], nd.x, nd.y, nd.z) then nd.inside=true; return; end
			end
			
		end
		
	end
end

function flagNodeExtended(x,y,z, nd)
	--reason for outcommenting: no dynamic change of node flags
	
	flagNode(nd)
	--local dx,dy,dz=normalized(nd.x-x,0,nd.z-z)
	nd.insideE=lineCollision(x,y,z, nd.x,y,nd.z, true)
	--nd.insideE=lineCollision(x+0.05*dx,0.2,z+0.05*dz, nd.x, 0.2,nd.z, true)
	if #nd.successors== 0 then
		--isolated nodes are bad for starting a path with
		nd.insideE=true
	end
end

function maybe_step_forward(pth, x,y,z)
	--while true do
		if pth.next==nil then return pth end
		if not lineCollision(pth.next.x,pth.next.y,pth.next.z, x,y,z, true) then
			pth=pth.next
		else
			--break
		end
	--end
	return pth
end


function mrnd(n)
	local rst=n-math.floor(n)
	if math.abs(rst)>=0.5 then return math.ceil(n) else return math.floor(n) end
end


function getNearestOutsideNode(nd, x,y,z)

	local cx=nd.x
	local cy=y
	local cz=nd.z
	local dx,dy,dz=normalized(x-cx,0,z-cz)
	local ndnew
	local c=0

	
	while true do
	
		cx=cx+dx
		cy=cy+dy
		cz=cz+dz
	
		ndnew=getNearestNodeOfPosition(cx,cy,cz)
		flagNode(ndnew)
		
		local dx2,dy2,dz2=normalized(x-ndnew.x,0,z-ndnew.z)
		if dot(dx,dy,dz, dx2,dy2,dz2)<0 then
			--senseless to move, this would be wrong direction	
			return nil
		end
	
	
		if not ndnew.inside and nd~=ndnew then return ndnew end
	end
end

function getNearestOutsideNode2(nd, x,y,z)

	local cx=nd.x
	local cy=y
	local cz=nd.z
	local dx,dy,dz=normalized(x-cx,0,z-cz)
	local ndnew
	local c=0

	
	while true do
	
		cx=cx+dx
		cy=cy+dy
		cz=cz+dz
	
		ndnew=getNearestNodeOfPosition(cx,cy,cz)
		flagNode(ndnew)
		
		
	
		if not ndnew.inside and nd~=ndnew then return ndnew end
	end
end


function drawSuccessors(x,y,z,depth)
	local node=getNearestNodeOfPosition(x,y,z)
	for i=1,#node.successors,1 do
			drawVertex(node.x, 0.2, node.z)
			drawLine(node.successors[i].x, 0.2, node.successors[i].z)
			if depth<5 then
				drawSuccessors(node.successors[i].x, 0.2, node.successors[i].z, depth+1)
			end
	end
end

function checkPathForDuplicates(pth)
	local pth_stepper=pth

	while pth_stepper do
		if pth_stepper.next then
			if pth_stepper.x==pth_stepper.next.x and pth_stepper.z==pth_stepper.next.z then 
				pth_stepper.next=pth_stepper.next.next
				--return true
		 	end
		 end
		pth_stepper=pth_stepper.next
	end
	return false
end

function generateAStarPathBetweenPositions(target, x2,y2,z2, x1,y1,z1)


	if target ~=nil then
		--x1,y1,z1=getObjectInfo(target.cObj, IG3D_POSITION)
	end

	--[[
	--perfom line of sight checks with three parallel lines, if none collides we are free to go
	dx=x1-x2
	dz=z1-z2
	dx,dy,dz=normalized(dx,0,dz)
	local c,x,y,z,o= lineCollision(x2,y2+0.5,z2, x1,y1+0.5,z1) 
	local wayIsFree=true
	
	if c==1 or (c==2 and o~=target) then
            wayIsFree=false
        else
            local ax,ay,az=cross(dx,dy,dz, 0,1,0)
            ax=ax*0.5
            ay=0
            az=az*0.5
            c,x,y,z,o= lineCollision(x2+ax,y2+0.5+ay,z2+az, x1+ax,y1+0.5+ay,z1+az)
            if c==1 or (c==2 and o~=target) then
                wayIsFree=false
            else
                c,x,y,z,o= lineCollision(x2-ax,y2+0.5-ay,z2-az, x1-ax,y1+0.5-ay,z1-az)
                if c==1 or (c==2 and o~=target) then
                    wayIsFree=false
                end
            end
        end
	
	if wayIsFree and target~=nil then return nil end -- no need for a star here!
	
	
	
	if wayIsFree then
		--no occluders, cool, now just walk there
                return {x=x2, y=y2, z=z2, next={x=x1, y=y1+0.5, z=z1, next=nil} }
	else
		local ds=vecLength(x1-x,y1+0.5-y,z1-z)
		if ds/gGridSize > 0 then
			--a star too expensive
			--print("a star too expensive, doing heuristic")
			x2=x
			y2=y
			z2=z
		end
		
	end

	
	--]]
	
	
	y2=y2-0.4--quick hack, y2 is the position of the object that moves most of the time!
	y1=y2--quick hack 2, dont climb floors
	
	--determine outside node in the area
	nds= getSurroundingNodesOfPosition(x1,y1,z1)
	nds2=nds
	
	--y1=nds[1].y[#nds[1].y]--hack
	flagNodeExtended(x1,y1,z1,nds[1])
	flagNodeExtended(x1,y1,z1,nds[2])
	flagNodeExtended(x1,y1,z1,nds[3])
	flagNodeExtended(x1,y1,z1,nds[4])
	--nds[1].insideE=false
	--nds[2].insideE=false
	--nds[3].insideE=false
	--nds[4].insideE=false
	
	local foundOutside1=false
	local dst1=vecLength(x1-nds[1].x, 0, z1-nds[1].z)
	local dst=1000
	local dst2=vecLength(x1-nds[2].x, 0, z1-nds[2].z)
	local dst3=vecLength(x1-nds[3].x, 0, z1-nds[3].z)
	local dst4=vecLength(x1-nds[4].x, 0, z1-nds[4].z)
	local nearestToStart
	if nds[1].inside == false and nds[1].insideE == false then nearestToStart=nds[1]; dst=dst1; foundOutside1 = true end
	if dst2<dst and nds[2].inside==false and nds[2].insideE == false then nearestToStart=nds[2]; dst=dst2; foundOutside1 = true end
	if dst3<dst and nds[3].inside==false and nds[3].insideE == false then nearestToStart=nds[3]; dst=dst3; foundOutside1 = true end
	if dst4<dst and nds[4].inside==false and nds[4].insideE == false then nearestToStart=nds[4]; dst=dst4; foundOutside1 = true end
	if not foundOutside1 then nearestToStart=nds[1] end
	
	


	
	
	--determine outside node in the area
	nds=nil
	nds= getSurroundingNodesOfPosition(x2,y2,z2)
	nds3=nds
	flagNodeExtended(x2,y2,z2,nds[1])
	flagNodeExtended(x2,y2,z2,nds[2])
	flagNodeExtended(x2,y2,z2,nds[3])
	flagNodeExtended(x2,y2,z2,nds[4])
	
	local foundOutside2=false
	dst1=vecLength(x1-nds[1].x, 0, z1-nds[1].z)
	dst=1000
	dst2=vecLength(x1-nds[2].x, 0, z1-nds[2].z)
	dst3=vecLength(x1-nds[3].x, 0, z1-nds[3].z)
	dst4=vecLength(x1-nds[4].x, 0, z1-nds[4].z)
	local nearestToEnd
	
	if nds[1].inside == false and nds[1].insideE == false then nearestToEnd=nds[1]; dst=dst1; foundOutside2 = true end
	if dst2<dst and nds[2].inside==false and nds[2].insideE == false then nearestToEnd =nds[2]; dst=dst2; foundOutside2 = true end
	if dst3<dst and nds[3].inside==false and nds[3].insideE == false then nearestToEnd =nds[3]; dst=dst3; foundOutside2 = true end
	if dst4<dst and nds[4].inside==false and nds[4].insideE == false then nearestToEnd =nds[4]; dst=dst4; foundOutside2 = true end
	if not foundOutside2 then nearestToEnd=nds[1] end
	
	gende=nearestToEnd
	ganfang=nearestToStart

	dx,dy,dz=normalized(x1-x2,0, z1-z2)
	
y1=nearestToStart.y--test
y2=nearestToEnd.y--test

--code to disable A*
--[[
	if true then 
local pth_tail = {x=x1, y=y1, z=z1, next=nil }
		pth_tail.last=pth_tail
		local pth_head={x=x1, y=y1, z=z1, last=pth_tail, next=pth_tail}
		local pth=pth_head 
		return pth_head
end
	--]]
	
	
	if not foundOutside1 then
		--this is a pretty rare case in outside levels when people flee
		--beep()
		--drawVertex(x1,y1,z1)
		--ig3d_SetMode_i(1)
		nearestToStart=getNearestOutsideNode2(nearestToStart, x2,y2,z2)
	end
	
	if not foundOutside2 then
		--
	end


	
	startNode=nearestToStart
	destinationNode=nearestToEnd
	
	local aStarSuccessful=false
	--first try: try to get inside
	if a_star(startNode, destinationNode)==1 then
		--success
		aStarSuccessful=true
	else
		--failed! second try: try to reach a point outside
		local i
		aStarSuccessful=false
		
		local lim=math.floor(vecLength(x2-x1,0,z2-z1))+1
		
		lim=math.min(lim, gMaxAStarPasses)
		for i=1,lim,1 do
			local nr=getNearestOutsideNode(startNode, x2,y2,z2) --returns nil if no meaningful movement possible
			if nr==nil then
				aStarSuccessful =false
				break
			else
				startNode=nr
				if a_star(startNode, destinationNode)==1 then
					aStarSuccessful=true
					break
				end
			end
		end
		
	end


	if aStarSuccessful then
		--is reachable
		
		local nd=destinationNode
		
		local pth_tail = {x=startNode.x, y=startNode.y, z=startNode.z, next=nil }
		pth_tail.last=pth_tail
		local pth_head={x=nd.x, y=nd.y, z=nd.z, last=pth_tail, next=nil}
		local pth=pth_head
		
		while nd~=nil do
			
			local tnd=nd.predecessor
			nd.predecessor=nil
			nd=tnd
			if nd~= nil then
				
				pth.next={x=nd.x, y=nd.y, z=nd.z, last=pth_tail, next=nil}
				pth=pth.next
					
				if nd.x==pth_tail.x and nd.z==pth_tail.z then break end --this is already the end, ignore any spare nodes
				
			end
		end
		
		
		--now check if another point in reach is the second point on the path, in this case we picked a bad start node and can go directly to this one node
		if pth_head.next then
		local j
		for j=1,4,1 do
			if pth_head.next.x==nds[j].x and pth_head.next.z==nds[j].z then
				--eliminate bad start nodes!!
				pth_head.x=nds[j].x
				pth_head.y=nds[j].y
				pth_head.z=nds[j].z
				
				break--!!!! very important
			end
		end
		end
		
		--for some reason the last point is sometimes not the destination point, make sure it is!
		pth.x=startNode.x
		pth.y=startNode.y
		pth.z=startNode.z
		if target and target~=playerBox then
			--danger, dont enable next three lines
			pth_tail.x=x1
			pth_tail.y=y1
			pth_tail.z=z1	
		end
		
		pth.next=pth_tail--haha, dirty trick, append the path tail
		return pth_head
	else
		local pth_tail = {x= x2, y=y2, z=z2, next=nil, last=nil }
		pth_tail.last=pth_tail
		local pth_head={x= x2, y=y2, z=z2, last=pth_tail, next=pth_tail}
		return pth_head
	end
end







function crazyJumpBack()
	if time()>crazyJumpBackTime then
		ig3d_SetMode_i(4)
	end
end



function setupAStarGrid()
	local sx,bx,sy,by,sz,bz=ig3d_GetMeshBounds__6f()
	
	--gNumRowVertices=200
	--gNumColumnVertices=200
	gGridSize=2--2
	--[[
	sx=sx-gGridSize
	bx=bx+gGridSize
	sz=sz-gGridSize
	bz=bz+gGridSize
	--]]
	gNumRowVertices=math.ceil( (bx-sx)/gGridSize) +1
	gNumColumnVertices=math.ceil( (bz-sz)/gGridSize ) +1

	
	--gXOffset=-gGridSize*(gNumRowVertices/2)
	--gZOffset=-gGridSize*(gNumColumnVertices/2)
	gXOffset=math.floor(sx/gGridSize)*gGridSize---1 --new adaptive grid should work a lot better
	gZOffset=math.floor(sz/gGridSize)*gGridSize---1 --new adaptive grid should work a lot better
	
	--need to put objects out of interesting area, so that they dont confuse the ray scanner for node creation
	for i=1,#gObjects,1 do
		x,y,z=getObjectInfo(gObjects[i].cObj, IG3D_POSITION)
		setObjectInfo(gObjects[i].cObj, IG3D_POSITION, x,y-1000,z)
	end
	
	createNodeGrid(gNumRowVertices, gNumColumnVertices, gXOffset, gZOffset, gGridSize)
	
	--reset object positions
	for i=1,#gObjects,1 do
		x,y,z=getObjectInfo(gObjects[i].cObj, IG3D_POSITION)
		setObjectInfo(gObjects[i].cObj, IG3D_POSITION, x,y+1000,z)
	end
end

