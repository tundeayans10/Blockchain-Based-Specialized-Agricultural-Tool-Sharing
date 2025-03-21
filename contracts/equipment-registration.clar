;; Equipment Registration Contract
;; Records details of specialized farm implements

(define-data-var last-equipment-id uint u0)

(define-map equipment
  { id: uint }
  {
    name: (string-ascii 100),
    type: (string-ascii 50),
    owner: principal,
    available: bool
  }
)

;; Register new equipment
(define-public (register-equipment
    (name (string-ascii 100))
    (type (string-ascii 50))
  )
  (let
    (
      (new-id (+ (var-get last-equipment-id) u1))
    )
    (var-set last-equipment-id new-id)

    (map-set equipment
      { id: new-id }
      {
        name: name,
        type: type,
        owner: tx-sender,
        available: true
      }
    )

    (ok new-id)
  )
)

;; Update equipment availability
(define-public (update-availability
    (equipment-id uint)
    (available bool)
  )
  (let
    (
      (item (unwrap! (map-get? equipment { id: equipment-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get owner item)) (err u403))

    (map-set equipment
      { id: equipment-id }
      (merge item { available: available })
    )

    (ok true)
  )
)

;; Get equipment details
(define-read-only (get-equipment (equipment-id uint))
  (map-get? equipment { id: equipment-id })
)

;; Get total equipment count
(define-read-only (get-equipment-count)
  (var-get last-equipment-id)
)
