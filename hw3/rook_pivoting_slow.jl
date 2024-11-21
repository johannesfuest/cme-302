function getrfRookSlow!(A)
    # Rook pivoting for rank-revealing LU
    n = size(A,1)
    P_row = collect(1:n); P_col = collect(1:n); 
    for k=1:n
    # Rook pivoting
        row = 1; row0 = 0; col = 1; col0 = 0 
        while row != row0 || col != col0
            row0 , col0 = row , col # Save old values 
            row_A = abs.(A[row+k-1, k:end])
            # Search in pivots’ row
            col = findmax(row_A)[2]
            col_A = abs.(A[k:end, col+k-1]) 
            # Search in pivot’s column
            row = findmax(col_A)[2]
        end
        # If we reach this line, this means that the pivot is the largest in its row and column.
        row += k-1; col += k-1

        # Swap rows and columns
        P_row[k], P_row[row] = P_row[row], P_row[k] 
        P_col[k], P_col[col] = P_col[col], P_col[k] 
        for j=1:n
            A[k,j],A[row,j] = A[row,j],A[k,j] 
        end

        for i=1:n
            A[i,k],A[i,col] = A[i,col],A[i,k]
        end

        # Perform usual LU step
        println("Size of rook pivot at ",k, ": ", A[k,k])
        # Find larges element in A[k:end, k:end]
        max_value = findmax(abs.(A[k:end, k:end]))
        println("Max value in remaining matrix at ",k, ": ", max_value)
        if abs(A[k,k]) > 1e-16
            for i=k+1:n
                A[i,k] /= A[k,k] 
            end
            for j=k+1:n, i=k+1:n
                A[i,j] -= A[i,k] * A[k,j]
            end 
        else # early termination
            return P_row, P_col, k-1
        end
    end
    return P_row ,P_col, k-1
end
