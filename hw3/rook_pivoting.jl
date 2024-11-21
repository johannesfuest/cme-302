function getrfRook!(A)
    # Rook pivoting LU:
    # function getrfRook!
    # Input: matrix A
    # Output: row permutation (as an array), column permutation (as an array), rank of A
    # The L and U factors are stored in the lower and upper triangular parts of A
    # The code should run in O(r^2 n) and NOT in O(r n^2)
    n = size(A,1)
    P_row = collect(1:n); P_col = collect(1:n);
    for k=1:n
        # Rook pivoting
        row = 1; row0 = 0; col = 1; col0 = 0 
        col_A = zeros(n-k+1)
        row_A = zeros(n-k+1)
        while row != row0 || col != col0
            row0 , col0 = row , col # Save old values 
            # Search in pivot’s row
            #init row_A as empty array
            row_A = zeros(n-k+1)
            for i=k:n
                row_sub = 0
                for j=1:k-1
                    row_sub += A[row + k-1, j] * A[j, i]
                end
                row_A[i-k+1] = A[row + k-1, i] - row_sub
            end

            # Search in pivots’ column
            col = findmax(abs.(row_A))[2]
            col_A = zeros(n-k+1)
            for i=k:n
                col_sub = 0
                for j=1:k-1
                    col_sub += A[i, j] * A[j, col + k-1]
                end
                col_A[i-k+1] = A[i, col + k - 1] - col_sub
            end
            # Search in pivot’s column
            row = findmax(abs.(col_A))[2]
        end
        #Move pivot to the correct position
        row_A[1], row_A[col] = row_A[col], row_A[1]
        col_A[1], col_A[row] = col_A[row], col_A[1]
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
        if k > 1
            # Write col_A to A[k:end, col+k-1]
            for i=k:n
                A[i, k] = col_A[i-k+1]
            end

            # Write row_A to A[row+k-1, k:end]
            for j=k:n
                A[k, j] = row_A[j-k+1]
            end
        end
        if abs(A[k,k]) > 1e-10
            # Update L
            for i=k+1:n
                A[i,k] /= A[k,k]
            end
        else # early termination
            return P_row, P_col, k-1
        end
    end
    return P_row, P_col, n
end
