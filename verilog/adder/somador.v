module somador(i0, i1, ci, s, co);

	input i0, i1, ci;
	output s, co;

	assign	{co,s} = i0 + i1 + ci;

endmodule