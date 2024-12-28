function EFFECT:Init( data )

    local vOffset = data:GetOrigin()

    local color = data:GetStart():ToColor()

    sound.Play( "garrysmod/balloon_pop_cute.wav", vOffset, 80, 100 )

    local NumParticles = 16

    local emitter = ParticleEmitter( vOffset, true )

    for i = 0, NumParticles do

        local particle = emitter:Add( "particles/balloon_bit", vOffset + VectorRand() * 12 )
        if ( particle ) then

            particle:SetVelocity( VectorRand() * 512 )

            particle:SetLifeTime( 0 )
            particle:SetDieTime( math.Rand(1, 1.5) )

            particle:SetStartAlpha( 255 )
            particle:SetEndAlpha( 255 )

            local Size = math.Rand( 3, 5 )
            particle:SetStartSize( Size )
            particle:SetEndSize( 0 )

            particle:SetRoll( math.Rand( 0, 360 ) )
            particle:SetRollDelta( math.Rand( -2, 2 ) )

            particle:SetAirResistance( 200 )
            particle:SetGravity( Vector( 0, 0, -75 ) )

            particle:SetColor( color.r, color.g, color.b )

            particle:SetCollide( true )

            particle:SetAngleVelocity( Angle( math.Rand( -160, 160 ), math.Rand( -160, 160 ), math.Rand( -160, 160 ) ) )

            particle:SetBounce( 0.7 )
            particle:SetLighting( false )
        end
    end
    emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end