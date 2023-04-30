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
    cnt = @showprogress "Generating..." @distributed (+) for category_id in
                                                       0:(num_categories-1)
        generate_instances(config; save_root, category_id, num_instances)
        true
    end
    @info "Done! $cnt classes should be generated in $(save_root) directory"
end

if abspath(Base.PROGRAM_FILE) == @__FILE__
    config_path = "config.toml"
    save_root = "VisualAtom_dataset"
    @sync begin
        @time generate_dataset(config_path, save_root)
    end
    @info "Exit $(Base.PROGRAM_FILE)"
end
