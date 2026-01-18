from num2words import num2words
for n_t in range(1, 5):
    for n_i in range(2, 5):
        total = n_i - 2 + 3 * (n_t - 1)
        if total % 6 == 5:
            filename = "instances/instance_" + str(n_t) + "_" + str(n_i) + ".pddl"
            out = open(filename, "w+")
            out.write("(define (problem p_" + str(n_t) + "_" + str(n_i) + ")\n\n")
            out.write("	(:domain new)\n\n")
            out.write("	(:objects\n")
            out.write("		")
            for i in range(n_i):
                out.write("i" + str(i) + " ")
            out.write("- Item\n")
            out.write("		")
            for t in range(n_t):
                out.write("t" + str(t) + " ")
            out.write("last_t ")
            out.write("- Treatment\n")
            out.write("	)\n\n")
            out.write("        (:init\n")
            out.write("              (start_item i0)\n")
            for i in range(1,n_i):
                out.write("              (next_item i"+str(i-1)+" i"+str(i)+")\n\n")
            for t in range(n_t-1):
                out.write("              (consecutive t"+str(t)+" t"+str(t+1)+")\n")
            out.write("              (consecutive t"+str(n_t-1)+" last_t)\n")
            for i in range(n_i):
                out.write("              (started i"+str(i)+" last_t)\n")
                out.write("              (ready i"+str(i)+" t0)\n")
            for i in range(n_i):
                for t in range(n_t):
                    out.write("              (not_started i"+str(i)+" t" + str(t) + ")\n")
                    out.write("              (not_treated i"+str(i)+" t" + str(t) + ")\n")
            for t in range(n_t):
                out.write("              (next_to_treat t"+str(t)+" i0)\n")
                out.write("              (not_is_end t"+str(t)+")\n")
            out.write("        )\n\n")
            out.write("	(:goal\n")
            out.write("              (and\n")
            out.write("                (joined)\n")
            out.write("              )\n")
            out.write("	)\n")
            out.write(")\n")
            out.close()