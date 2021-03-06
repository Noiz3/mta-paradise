--[[
Copyright (c) 2010 MTA: Paradise

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

addCommandHandler( { "spectate", "spec", "recon" },
	function( player, commandName, other )
		local name
		if other then
			other, name = exports.players:getFromName( player, other )
			if not other then
				return
			end
		end
		
		if not exports.freecam:isPlayerFreecamEnabled( player ) then
			if isElementAttached( player ) then
				if getElementType( getElementAttachedTo( player ) ) == "player" then
					if other then
						local interior, dimension = getElementInterior( player ), getElementDimension( player )
						setElementDimension( player, getElementDimension( other ) )
						setElementInterior( player, getElementInterior( other ) )
						if attachElements( player, other, 0, 0, -5 ) then
							outputChatBox( "You are now watching " .. name .. ".", player, 0, 255, 0 )
							for key, value in ipairs( getElementsByType( "player" ) ) do
								if hasObjectPermissionTo( value, "command.spectate", false ) then
									outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " is now watching " .. name .. ".", value, 0, 255, 153 )
								end
							end
						else
							outputChatBox( "Couldn't attach you to the player.", player, 255, 0, 0 )
							setElementInterior( player, interior )
							setElementDimension( player, dimension )
						end
					elseif type( getElementData( player, "collisionless" ) ) == "table" then
						local x, y, z, dimension, interior = unpack( getElementData( player, "collisionless" ) )
						removeElementData( player, "collisionless" )
						
						detachElements( player )
						setElementPosition( player, x, y, z )
						setElementDimension( player, dimension )
						setElementInterior( player, interior )
						setElementAlpha( player, 255 )
						setCameraTarget( player )
					else
						outputChatBox( "You're not watching anyone.", player, 255, 0, 0 )
					end
				else
					outputChatBox( "Please unglue yourself first.", player, 255, 0, 0 )
				end
			elseif other then
				local x, y, z = getElementPosition( player )
				local interior, dimension = getElementInterior( player ), getElementDimension( player )
				setElementDimension( player, getElementDimension( other ) )
				setElementInterior( player, getElementInterior( other ) )
				if attachElements( player, other, 0, 0, -5 ) then
					setElementData( player, "collisionless", true ) -- synced to have the player collisionless
					setElementData( player, "collisionless", { x, y, z, dimension, interior }, false ) -- our data only
					setElementDimension( player, getElementDimension( other ) )
					setElementInterior( player, getElementInterior( other ) )
					setElementAlpha( player, 0 )
					setCameraTarget( player, other )
					outputChatBox( "You are now watching " .. name .. ".", player, 0, 255, 0 )
					for key, value in ipairs( getElementsByType( "player" ) ) do
						if hasObjectPermissionTo( value, "command.spectate", false ) then
							outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " is now watching " .. name .. ".", value, 0, 255, 153 )
						end
					end
				else
					outputChatBox( "Couldn't attach you to " .. name .. ".", player, 255, 0, 0 )
					setElementInterior( player, interior )
					setElementDimension( player, dimension )
				end
			else
				outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
			end
		else
			outputChatBox( "Please disable /freecam first.", player, 255, 0, 0 )
		end
	end,
	true
)
