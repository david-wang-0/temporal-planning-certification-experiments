from num2words import num2words
import math
for n_r in range(1, 4): # robots
    for n_b in range(2, 5): # pallets
        for n_p in range(3, 7): # positions
            for n_t in range(1, 5): # treatments
                total = (n_t - 1) + 4 * (n_p - 3) + 16 * (n_b - 2) + 48 * (n_r - 1)
                if total % 6 == 5:
                    filename = "instances/instance_" + str(n_r) + "_" + str(n_b) + "_" + str(n_p) + "_" + str(n_t) + ".pddl"
                    out = open(filename, "w+")
                    out.write("(define (problem p_" + str(n_r) + "_" + str(n_b) + "_" + str(n_p) + "_" + str(n_t) + ")\n\n")
                    out.write("	(:domain majsp)\n\n")
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

                    max_battery = math.floor(((n_p-2+n_t)*(n_b-1))/n_r) # how do we calculate the fuel needed for each robot
                    out.write("		")
                    for t in range(max_battery+1):
                        out.write(num2words(t) + " ")
                    out.write("- Nat \n")

                    out.write("	)\n\n")
                    out.write("        (:init\n")
                    for t in range(max_battery):
                        out.write("              (next_nat " + num2words(t) + " " + num2words(t+1) + ")\n")
                    out.write("\n")
                    # all robots
                    for i in range(n_r):
                        out.write("              (robot_at r" + str(i) + " p" + str(n_p-1) + ")\n")
                        out.write("              (robot_free r" + str(i) + ")\n")
                        out.write("              (battery_level r" + str(i) + " " + num2words(max_battery) + ")\n")
                    out.write("\n")
                    
                    # all pallets are at the max_location

                    for i in range(n_b):
                            out.write("              (pallet_at b" + str(i) + " p" + str(n_p-1) + ")\n")
                    out.write("\n")

                    # max_location is a depot
                    out.write("              (is_depot p" + str(n_p-1) + ")\n")
                    out.write("\n")
                    # positions are free
                    for i in range(n_p):
                        out.write("              (position_free p" + str(n_p-1) + ")\n")
                    out.write("\n")
                    # if there are more treatments than positions, then make them all possible at position 0, else pair them
                    if n_t > n_p:
                            out.write("              (can_do p" + str(i) + " t0)\n")
                    else:
                        for i in range(n_t):
                            out.write("              (can_do p" + str(i) + " t" + str(i) + ")\n")

                    # positions are connected
                    for i in range(n_p-1):
                        out.write("              (connected p" + str(i) + " p" + str(i+1) + ")\n")
                        out.write("              (connected p" + str(i+1) + " p" + str(i) + ")\n")
                    out.write("\n")

                    out.write("        )\n\n")
                    out.write("	(:goal\n")
                    out.write("              (and\n")
                    # every pallet is treated with every treatment
                    for i in range(n_b):
                        for j in range(n_t):
                            out.write("              (treated b" + str(i) + " t" + str(j) + ")\n")
                    out.write("              )\n")
                    out.write("	)\n")
                    out.write(")\n")
                    out.close()
