AddEventHandler('playerConnecting',
    function(name, _, deferrals)
        local src = source
        deferrals.defer()
        local license = GetPlayerIdentifierByType(src, 'license')
        print(name .. " - " .. license)

        Wait(0)
        deferrals.update("Checking Membership")
        if not (name == 'DoktorPengar' or 'Bernard9') then
            print("Denied ".. name .." connection!")
            return deferrals.done("You must first join our Discord to join the server")
        end

        Wait(0)
        deferrals.update("Jämför dig med vårt register")

        Wait(0)
        deferrals.done()
        print(name .. " joined!")
    end
)
