using Agents, Random, CairoMakie, ReinforcementLearning

extent = (10, 10)


@agent struct ShipAgent(ContinuousAgent{2,Float64})
    health::Int64
    side::Int64
end

function model_step!(model)
    for agent in allagents(model)
        move_agent!(agent, model, 1)
    end
end

function init_horizons(; map_size=(10, 10), agents_per_side=1, side_count=2, seed=12)
    space = ContinuousSpace(map_size;)
    rng = Xoshiro(seed)
    model = StandardABM(
        ShipAgent, space;
        model_step!, rng
    )

    for n in 1:side_count*agents_per_side
        add_agent!(model; vel=rand(abmrng(model), 2), side=n % side_count, health=12)
    end

    return model
end

model = init_horizons()

step!(model)

agent_color(a) = a.side == 1 ? :blue : :orange

abmvideo(
    "horizons.mp4", model;
    agent_color,
    framerate=4, frames=20,
    title="horizons"
)
