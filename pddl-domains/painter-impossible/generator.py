from num2words import num2words
for n_t in range(1, 5):
    for n_i in range(2, 5):
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
        out.write("- Treatment\n")
        out.write("     ")
        for i in range(n_i + 1):
            out.write(num2words(i) + " ")
        out.write("- Nat\n")
        out.write("	)\n\n")
        out.write("        (:init\n")
        for i in range(n_i):
            out.write("              (next_count " + num2words(i) + " " + num2words(i+1) + ")\n")
        out.write("              (not_busy)\n")
        out.write("              (true)\n")
        for i in range(n_i):
            for t in range(n_t):
                out.write("              (not_treated i"+str(i)+" t"+str(t)+")\n")
        for i in range(n_i):
            for t in range(n_t):
                out.write("              (not_started i"+str(i)+" t"+str(t)+")\n")
        for i in range(n_i):
            out.write("              (item_id i"+str(i)+" "+num2words(i)+")\n")
        for t in range(n_t-1):
            out.write("              (consecutive t"+str(t)+" t"+str(t+1)+")\n")
        out.write("              (consecutive t"+str(n_t-1)+" last_t)\n")
        for i in range(n_i):
            out.write("              (started i"+str(i)+" last_t)\n")
            out.write("              (ready i"+str(i)+" t0)\n")
        for t in range(n_t):
            out.write("              (counter t"+str(t)+" zero)\n")
            out.write("              (not_is_end t"+str(t)+")\n")
        out.write("              (counter last_t zero)\n")
        out.write("        )\n\n")
        out.write("	(:goal\n")
        out.write("              (and\n")
        out.write("                (joined)\n")
        out.write("              )\n")
        out.write("	)\n")
        out.write(")\n")
        out.close()
