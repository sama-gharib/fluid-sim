export OMP_NUM_THREADS := 4

run: fluid-sim
	@./fluid-sim

fluid-sim: fortran-raylib modules src/*.f90
	@gfortran --max-errors="1" src/vector_operations.f90 src/simulation.f90 src/main.f90 -o fluid-sim -O3 -Ifortran-raylib -J modules -lraylib -fopenmp

modules:
	@mkdir modules

fortran-raylib:
	@echo "Cloning fortran-raylib..."
	@git clone https://github.com/interkosmos/fortran-raylib.git
	@echo "Done."
	@echo "Building fortran-raylib..."
	@make -C fortran-raylib/
	@echo "Done."

clean:
	@rm -rf fortran-raylib
	@rm -rf modules
	@rm fluid-sim