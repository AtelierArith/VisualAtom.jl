using Distributed: @distributed, @everywhere, nprocs
using TOML

using VisualAtom: Config
using VisualAtom: generate_instances
using ToStruct: tostruct
using ProgressMeter: @showprogress

# https://docs.julialang.org/en/v1/stdlib/Distributed/
@everywhere using VisualAtom: generate_instances

function generate_dataset(
    config_path::AbstractString,
    save_root::AbstractString,
)
    @info "Read configuration:" config_path
    config = tostruct(Config, TOML.parsefile(config_path))

    num_categories = config.num_categories
    num_instances = config.num_instances

    @info "Generate VisualAtom dataset" num_categories num_instances nprocs()
    @showprogress @distributed for category_id in 0:(num_categories-1)
        generate_instances(config; save_root, category_id, num_instances)
    end
    println("Done! checkout $(save_root)")
end

if abspath(PROGRAM_FILE) == @__FILE__
    config_path = "config.toml"
    save_root = "VisualAtom_dataset"
    @time generate_dataset(config_path, save_root)
end
