from num2words import num2words
for n_r in range(1, 4): # robots
    for n_b in range(2, 5): # pallets
        for n_p in range(2, 7): # positions
            for n_t in range(1, 5): # treatments
                filename = "instances/instance_" + str(n_r) + "_" + str(n_pl) + "_" + str(n_p) + "_" + str(n_t) + ".pddl"
                out = open(filename, "w+")
                out.write("(define (problem p_" + str(n_r) + "_" + str(n_pl) + "_" + str(n_p) + "_" + str(n_t) + ")\n\n")
                out.write("	(:domain new)\n\n")
                out.write("	(:objects\n")

                out.write("		")
                for i in range(n_r):
                    out.write("r" + str(i) + " ")
                out.write("- Robot\n")

                out.write("		")
                for t in range(n_p):
                    out.write("p" + str(t) + " ")
                out.write("- Position\n")
                

                out.write("		")
                for t in range(n_t):
                    out.write("t" + str(t) + " ")
                out.write("- Treatment\n")

                out.write("		")
                for t in range(n_b):
                    out.write("b" + str(t) + " ")
                out.write("- Pallet \n")

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
