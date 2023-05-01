using .Threads: @atomic, @threads, nthreads
using TOML

using VisualAtom: Config
using VisualAtom: generate_instances
using ToStruct: tostruct
using ProgressMeter: Progress, next!, finish!

mutable struct AtomicCounter
    @atomic count::Int
    AtomicCounter(count=0) = new(count)
end

function generate_dataset(
    config_path::AbstractString,
    save_root::AbstractString,
)
    @info "Read configuration:" config_path
    config = tostruct(Config, TOML.parsefile(config_path))

    num_categories = config.num_categories
    num_instances = config.num_instances

    counter = AtomicCounter()
    p = Progress(num_categories, "Generating...")

    @info "Generate VisualAtom dataset" num_categories num_instances nthreads()
    @threads for category_id in 0:(num_categories-1)
        generate_instances(config; save_root, category_id, num_instances)
        @atomic counter.count += 1
        next!(p)
    end
    finish!(p)
    @info "Done! $(counter.count) classes should be generated in $(save_root) directory"
end

if abspath(Base.PROGRAM_FILE) == @__FILE__
    config_path = "config.toml"
    save_root = "VisualAtom_dataset"
    @time generate_dataset(config_path, save_root)
    @info "Exit $(Base.PROGRAM_FILE)"
end
