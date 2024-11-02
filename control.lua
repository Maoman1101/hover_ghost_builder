local build_entity_ghost    = require("modules.build_ghost")
local fill_request_proxies  = require("modules.fill_request_proxies")
local mine_entity           = require("modules.mine_entity")

local ghost_builder_enabled = {}
local function set_ghost_builder_enabled(player, value)
    ghost_builder_enabled[player.index] = value
    pcall(function()
        player.set_shortcut_toggled("ghost-builder-toggle", value)
    end)
end

local function get_ghost_builder_enabled(player)
    local enabled = ghost_builder_enabled[player.index]
    if enabled ~= nil then return enabled end
    enabled = true
    pcall(function()
        enabled = player.is_shortcut_toggled("ghost-builder-toggle")
    end)
    return enabled
end

local function toggle_ghost_builder(player)
    local enabled = not get_ghost_builder_enabled(player)
    set_ghost_builder_enabled(player, enabled)
    player.print(enabled and "Auto Ghost Builder enabled" or "Auto Ghost Builder disabled")
end


-- Event for checking and building ghosts
script.on_event(defines.events.on_selected_entity_changed, function(event)
    local player = game.get_player(event.player_index)

    if not player then return end
    if not get_ghost_builder_enabled(player) then return end

    -- Check if the player is hovering over a ghost entity
    local hovered_entity = player.selected
    if not hovered_entity then return end
    if hovered_entity.name == "entity-ghost" then
        build_entity_ghost(player, hovered_entity)
    else
        fill_request_proxies(player, hovered_entity)
        mine_entity(player, hovered_entity)
    end
end)

commands.add_command("toggle-ghost-builder", "toggle gover ghost builder", function(event)
    local player = game.get_player(event.player_index)
    if not player then return end
    toggle_ghost_builder(player)
end)
