function FullPivotLU!(A)
    # Rook pivoting for rank-revealing LU
    n = size(A,1)
    P_row = collect(1:n); P_col = collect(1:n);
    for k=1:n
        # Rook pivoting
        row = argmax(abs.(A[k:n, k:n]))[1]
        col = argmax(abs.(A[k:n, k:n]))[2]
        
        row += k-1
        col += k-1
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
        if A[k,k] != 0
            for i=k+1:n
                A[i,k] /= A[k,k]
            end
            for j=k+1:n, i=k+1:n
                A[i,j] -= A[i,k] * A[k,j]
            end
        end
    end
    return P_row, P_col
end
