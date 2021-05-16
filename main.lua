px, py, pdx, pdy, pa = 0, 0, 0, 0, 0
mapX = 8
mapY = 8
mapS = 65
PI = math.pi
P2 = PI / 2
P3 = 3 * PI / 2
DR = 0.0174533
map = {1, 1, 1, 1, 1, 1, 1, 1, 
       1, 1, 1, 0, 0, 1, 1, 1,
       1, 1, 0, 0, 0, 0, 1, 1, 
       1, 0, 0, 0, 0, 0, 0, 1, 
       1, 0, 0, 0, 0, 0, 1, 1, 
       1, 1, 0, 0, 0, 0, 1, 1, 
       1, 1, 1, 0, 0, 1, 1, 1, 
       1, 1, 1, 1, 1, 1, 1, 1}
function DrawMap()
    xo, yo = nil, nil
    for y = 0, mapY do
        for x = 0, mapX - 1 do
            if map[(y * mapX + x) + 1] == 1 then
                love.graphics.setColor(1, 1, 1, 1)
            else
                love.graphics.setColor(0, 0, 0, 1)
            end
            xo = x * mapS
            yo = y * mapS
            love.graphics.rectangle('fill', xo + 1, yo + 1, mapS - 1, mapS - 1)
        end
    end
end

function DrawRays3D()
    r, mx, my, mp, dof, rx, ry, ra, xo, yo = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    ra = pa - DR * 30
    if ra < 0 then
        ra = ra + 2 * math.pi
    end
    if ra > 2 * math.pi then
        ra = ra - 2 * math.pi
    end
    for r = 0, 60 do
        dof = 0
        distH = 10000000000
        hx = px
        hy = py
        aTan = -1 / math.tan(ra)
        if ra > math.pi then
            ry = math.floor(py / 64) * 64 - 0.0001
            rx = (py - ry) * aTan + px
            yo = -64
            xo = -yo * aTan
        end
        if ra < math.pi then
            ry = math.floor(py / 64) * 64 + 64
            rx = (py - ry) * aTan + px
            yo = 64
            xo = -yo * aTan
        end

        if ra == 0 or ra == math.pi then
            rx = px
            ry = py
            dof = 8
        end

        while dof < 8 do
            mx = math.floor(rx / 64)
            my = math.floor(ry / 64)
            mp = (my * mapX + mx)
            if mp > 0 and mp < mapX * mapY and map[mp + 1] > 0 then
                dof = 8
                hx = rx
                hy = ry
                distH = dist(px, py, hx, hy, ra)
            else
                rx = rx + xo
                ry = ry + yo
                dof = dof + 1
            end
        end

        dof = 0
        distV = 10000000000
        vx = px
        vy = py
        nTan = -math.tan(ra)
        if ra > P2 and ra < P3 then
            rx = math.floor(py / 64) * 64 - 0.0001
            ry = (px - rx) * nTan + py
            xo = -64
            yo = -xo * nTan
        end
        if ra < P2 or ra > P3 then
            rx = math.floor(px / 64) * 64 + 64
            ry = (px - rx) * nTan + py
            xo = 64
            yo = -xo * nTan
        end

        if ra == 0 or ra == math.pi then
            rx = px
            ry = py
            dof = 8
        end

        while dof < 8 do
            mx = math.floor(rx / 64)
            my = math.floor(ry / 64)
            mp = (my * mapX + mx)
            if mp > 0 and mp < mapX * mapY and map[mp + 1] > 0 then
                dof = 8
                vx = rx
                vy = ry
                distV = dist(px, py, vx, vy, ra)
            else
                rx = rx + xo
                ry = ry + yo
                dof = dof + 1
            end
        end

        if distV < distH then
            rx = vx
            ry = vy
            disT = distV
            love.graphics.setColor(0.9, 0, 0, 1)
        else
            rx = hx
            ry = hy
            disT = distH
        love.graphics.setColor(0.7, 0, 0, 1)
        end

        love.graphics.setLineWidth(1)
        love.graphics.line(px, py, rx, ry)

        ca = pa - ra
        if ca < 0 then
            ca = ca + 2 * math.pi
        end
        if ca > 2 * math.pi then
            ca = ca - 2 * math.pi
        end
        disT = disT * math.cos(ca)
        lineH = math.min(320, (mapS * 320) / disT)
        lineO = 160 - lineH / 2
        love.graphics.setLineWidth(8)
        love.graphics.line(r * 8 + 530, lineO, r * 8 + 530, lineH+ lineO)

        ra = ra + DR
        if ra < 0 then
            ra = ra + 2 * math.pi
        end
        if ra > 2 * math.pi then
            ra = ra - 2 * math.pi
        end
    end

end

function love.load()
    love.window.setMode(1024, 512)
    px = 300
    py = 300
    pdx = math.cos(pa) * 5
    pdy = math.sin(pa) * 5
end
function love.draw()
    love.graphics.clear(0.3, 0.3, 0.3)
    DrawMap()
    DrawPlayer()
    DrawRays3D()

end
function love.update(dt)
    buttons()
end
function DrawPlayer()
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.setPointSize(8)
    love.graphics.points(px, py)
    love.graphics.setLineWidth(3)
    love.graphics.line(px, py, px + pdx * 5, py + pdy * 5)

end

function buttons()
    if love.keyboard.isDown('a') then
        pa = pa - 0.1
        if pa < 0 then
            pa = pa + 2 * math.pi
        end
        pdx = math.cos(pa) * 5
        pdy = math.sin(pa) * 5
    end
    if love.keyboard.isDown('d') then
        pa = pa + 0.1
        if pa > 2 * math.pi then
            pa = pa - 2 * math.pi
        end
        pdx = math.cos(pa) * 5
        pdy = math.sin(pa) * 5
    end
    if love.keyboard.isDown('w') then
        px = px + pdx
        py = py + pdy
    end
    if love.keyboard.isDown('s') then
        px = px - pdx
        py = py - pdy
    end

end

function dist(ax, ay, bx, by, ang)
    return math.sqrt((bx - ax) * (bx - ax) + (by - ay) * (by - ay))
end
