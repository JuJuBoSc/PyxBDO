function GetInvertedTriangleList(x, y, z, width, height, colorBottom, colorHeight)
    return 
    {
        { x + width, y + height, z, colorHeight },
        { x, y + height, z + width, colorHeight },
        { x, y, z, colorBottom },
        
        { x, y - width + height, z, colorHeight },
        { x - width, y + height, z, colorHeight },
        { x, y, z, colorBottom },
        
        { x + width, y + height, z, colorHeight },
        { x , y + height, z - width, colorHeight },
        { x, y, z, colorBottom },
        
        { x - width, y + height, z, colorHeight },
        { x , y + height, z + width, colorHeight },
        { x, y, z, colorBottom },
        
        { x - width, y + height, z, colorHeight },
        { x , y + height, z + width, colorHeight },
        { x + width, y + height, z, colorHeight },
        
        { x + width, y + height, z, colorHeight },
        { x , y + height, z - width, colorHeight },
        { x - width, y + height, z, colorHeight }
    }
end

