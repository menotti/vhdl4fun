entity t_somador is
end t_somador;
     
architecture behav of t_somador is
    --  Declaração do componente.
    component somador
       port (i0, i1 : in bit; ci : in bit; s : out bit; co : out bit);
    end component;
        --  Specifies which entity is bound with the component.
    for somador_0: somador use entity work.somador;
        signal i0, i1, ci, s, co : bit;
    begin
     --  Component instantiation.
     somador_0: somador port map (i0 => i0, i1 => i1, ci => ci,
                                 s => s, co => co);
     
     --  This process does the real job.
     process
        type pattern_type is record
          --  The inputs of the somador.
          i0, i1, ci : bit;
          --  The expected outputs of the somador.
          s, co : bit;
        end record;
           --  The patterns to apply.
        type pattern_array is array (natural range <>) of pattern_type;
        constant patterns : pattern_array :=
          (('0', '0', '0', '0', '0'),
           ('0', '0', '1', '1', '0'),
           ('0', '1', '0', '1', '0'),
           ('0', '1', '1', '0', '1'),
           ('1', '0', '0', '1', '0'),
           ('1', '0', '1', '0', '1'),
           ('1', '1', '0', '0', '1'),
           ('1', '1', '1', '1', '1'));
        begin
           --  Check each pattern.
           for i in patterns'range loop
              --  Set the inputs.
              i0 <= patterns(i).i0;
              i1 <= patterns(i).i1;
              ci <= patterns(i).ci;
              --  Wait for the results.
              wait for 1 ns;
              --  Check the outputs.
              assert s = patterns(i).s
                 report "bad sum value" severity error;
              assert co = patterns(i).co
                 report "bad carry out value" severity error;
           end loop;
           assert false report "end of test" severity note;
           --  Wait forever; this will finish the simulation.
           wait;
        end process;
     end behav;

