Framework = {}
Framework.Players = {}
-- Defaults
Framework.Player = {
    money = 150,
    bank = 1000,
    crypto = 0,
    identifier = nil
}

function Framework:GeneratePhoneNumber()
    return math.random(111,999) .. '-' .. math.random(1000,9999)
end

function Framework:GeneralSerialNumber()
    return math.random(11111111, 99999999)
end

function Framework:GenerateLog()
    --to be done
end

function Framework:GetIdentifier(source)
    return GetPlayerIdentifierByType(source, 'license')
end

function Framework:GetFrameworkID()

end

function Framework:GetCharacters()

end

function Framework:SelectCharacter(source, characterId)
    -- load selected character data and overwrite Framework.Players[source] start of switching characters without leaving server
end



